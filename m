Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3EMG7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:59:17 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:33181 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190Ab3EMG7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:59:16 -0400
Message-ID: <51908DED.7090701@st.com>
Date: Mon, 13 May 2013 07:53:33 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: debugfs: Fix start_reg calculation (v2)
References: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com> <20130512145906.GC4046@sirena.org.uk>
In-Reply-To: <20130512145906.GC4046@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On 12/05/13 15:59, Mark Brown wrote:
> On Wed, May 08, 2013 at 11:20:09AM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> If we dump syscon regmap registers via debugfs you will notice that the
>> dump contains lot of XXXXXXXX values.
> 
> Sorry, can you please rebase this against v3.10-rc1?  This patch was
> against v3.9 and I'm not now convinced that the issue still exists.
> 
I did try 3.10-rc1, and I can not reproduce the issue.
very similar patch "regmap: debugfs: Simplify calculation of
`c->max_reg'" addressed the issue.

However It looks like one of the return from the
regmap_debugfs_get_dump_start() still returns wrong register offset.

<snip>
if (from >= c->min && from <= c->max) {
       fpos_offset = from - c->min;
       reg_offset = fpos_offset / map->debugfs_tot_len;
       *pos = c->min + (reg_offset * map->debugfs_tot_len);
       mutex_unlock(&map->cache_lock);
       return c->base_reg + reg_offset;
}
</snip>

Thanks,
srini

