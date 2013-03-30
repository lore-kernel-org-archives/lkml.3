Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3C3IJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 04:09:48 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:36894 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab3C3IJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 04:09:44 -0400
Message-ID: <51569E4A.2080006@metafoo.de>
Date: Sat, 30 Mar 2013 09:11:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Shawn Guo <shawn.guo@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH 3/6] i2c: Ignore return value of i2c_del_adapter()
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>	<1362853009-20789-4-git-send-email-lars@metafoo.de> <20130330085539.442321fa@endymion.delvare>
In-Reply-To: <20130330085539.442321fa@endymion.delvare>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 03/30/2013 08:55 AM, Jean Delvare wrote:
> Hi Lars-Peter,
> 
> On Sat,  9 Mar 2013 19:16:46 +0100, Lars-Peter Clausen wrote:
>> i2c_del_adapter() always returns 0.
> 
> I beg you pardon? i2c_del_adapter() starts with:
> 
> int i2c_del_adapter(struct i2c_adapter *adap)
> {
> 	int res = 0;
> 	struct i2c_adapter *found;
> 	struct i2c_client *client, *next;
> 
> 	/* First make sure that this adapter was ever added */
> 	mutex_lock(&core_lock);
> 	found = idr_find(&i2c_adapter_idr, adap->nr);
> 	mutex_unlock(&core_lock);
> 	if (found != adap) {
> 		pr_debug("i2c-core: attempting to delete unregistered "
> 			 "adapter [%s]\n", adap->name);
> 		return -EINVAL;
> 	}
> 
> 	/* Tell drivers about this removal */
> 	mutex_lock(&core_lock);
> 	res = bus_for_each_drv(&i2c_bus_type, NULL, adap,
> 			       __process_removed_adapter);
> 	mutex_unlock(&core_lock);
> 	if (res)
> 		return res;
> (...)
> 
> So, no, it doesn't "always return 0".
> 

Patch 1 and 2 in this series remove those two instances:
https://lkml.org/lkml/2013/3/9/72
https://lkml.org/lkml/2013/3/9/86

For an explanation why this should be done please take a look at the cover
letter to this patch series https://lkml.org/lkml/2013/3/9/73

- Lars
