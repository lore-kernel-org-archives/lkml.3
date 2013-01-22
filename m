Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3AVIAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:00:43 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33107 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047Ab3AVIAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:00:42 -0500
Message-ID: <50FE477D.7060401@metafoo.de>
Date: Tue, 22 Jan 2013 09:02:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Peter Huewe <peterhuewe@gmx.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio: Use correct argument for sizeof
References: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de> <20130122064351.GV4584@mwanda>
In-Reply-To: <20130122064351.GV4584@mwanda>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 07:43 AM, Dan Carpenter wrote:
> On Mon, Jan 21, 2013 at 10:14:02PM +0100, Peter Huewe wrote:
>> found with coccicheck
>> sizeof when applied to a pointer typed expression gives the size of
>> the pointer
>>
> 
> The original code is correct, in this case.  We're storing an array
> of pointers and the last element in the array is a NULL.
> 

The patch changed sizeof(st->attrs) to sizeof(*st->attrs). The type of
st->attrs is struct attribute **, so both sizeofs return the same value (the
size of an pointer) and the code happens to work, still the later is
semantically more correct.


>> The semantic patch that makes this output is available
>> in scripts/coccinelle/misc/noderef.cocci.
>>
>> More information about semantic patching is available at
>> http://coccinelle.lip6.fr/
> 
> Can you remove those two boiler plate lines?  We all have google.

It would be nice to have a pointer to the specific cocci script used to
generate the patch though.

- Lars
