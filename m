Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaKIJiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:38:17 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48425 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaKIJiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:38:11 -0500
Message-ID: <545F35FB.20100@konagma.com>
Date: Sun, 09 Nov 2014 09:38:03 +0000
From: Krzysztof Konopko <kris@konagma.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8188eu: Remove unnecessary braces for simple return
 in xmit_linux.c
References: <1415481253-12281-1-git-send-email-kris@konagma.com> <1415481824.23530.35.camel@perches.com>
In-Reply-To: <1415481824.23530.35.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 21:23, Joe Perches wrote:
> On Sat, 2014-11-08 at 22:14 +0100, Krzysztof Konopko wrote:
>> scripts/checkpatch.pl reports a coding style problem in xmit_linux.c
> []
>> diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
> []
>> @@ -67,9 +67,8 @@ uint _rtw_pktfile_read(struct pkt_file *pfile, u8 *rmem, uint rlen)
>>  int rtw_endofpktfile(struct pkt_file *pfile)
>>  {
>>  
>> -	if (pfile->pkt_len == 0) {
>> +	if (pfile->pkt_len == 0)
>>  		return true;
>> -	}
>>  
>>
>>  	return false;
> 
> This should probably be
> 
> bool rtw_endofpktfile(const struct pkt_file *pfile_
> {
> 	return !pfile->pkt_len;
> }
>

Thanks for looking into it.

I see your point about making it a single return statement.  I tend to
shorten things as well.  I'd keep it as this:

bool rtw_endofpktfile(const struct pkt_file *pfile_
{
 	return pfile->pkt_len == 0;
}

Usign `!` operator suggests the variable is boolean although the name
suggests it isn't.  I'm not so familiar with the linux kernel code base
yet to justify it myself but I see no harm in making it slightly more
explicit.

> or just removed altogether and tested directly
> in the one place it's used.
> 
> 

It looks to me that the original intention was to open a possibility to
define the end of packet file in a OS dependent way so I'd leave it.

Or, if the counter argument is that non-Linux functionality should not
appear in this driver, the rest of non-Linux code should be removed in
the first place.  I'm not in position to even have an opinion on this.

The sole point of this patch was to fix a coding style problem but the
change you suggest seems still relevant.  I'll resend unless you have
strong objections on using `==` operator explicitly in the return statement.

Cheers,
Kris
