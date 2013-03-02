Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3CBN1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:27:13 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4171 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab3CBN1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:27:09 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5131FE1F.5010309@broadcom.com>
Date: Sat, 2 Mar 2013 14:26:55 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Andy Whitcroft" <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch bailing out
References: <5131EA60.40607@broadcom.com>
 <1362229674.2254.5.camel@joe-AO722>
In-Reply-To: <1362229674.2254.5.camel@joe-AO722>
X-WSS-ID: 7D2F222E23C6087755-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/13 14:07, Joe Perches wrote:
> On Sat, 2013-03-02 at 13:02 +0100, Arend van Spriel wrote:
>> With my laptop being broken I have to work on a server provided by my
>> employer and I am preparing some patches for submission. So I intended
>> to run checkpatch, but I get the following message after which the
>> script bails out:
>>
>> $ git format-patch -1 --stdout | scripts/checkpatch.pl -
>> Nested quantifiers in regex; marked by<-- HERE in m/(\((?:[^\(\)]++<--
>> HERE |(?-1))*\))/ at scripts/checkpatch.pl line 347.
>>
>> The server runs RHEL5
>>
>> 2.6.18-308.20.1.el5 #1 SMP x86_64 GNU/Linux
>>
>> Perl interpreter:
>>
>> $ /usr/bin/perl -v
>>
>> This is perl, v5.8.8 built for x86_64-linux-thread-multi
>>
>> My repository is based on wireless-testing repo.
>>
>> Did a quick search on LKML, but not finding anything like this. Any help
>> would be appreciated here.
>
> Sorry, I don't have perl 5.8.8, it's pretty old.
>
> Perhaps this explains it:
> http://www.perlmonks.org/?node_id=971814 (question)
> http://www.perlmonks.org/?node_id=971883 (explanation)
>
> Perhaps you could test this patch?

No luck. Fails on the same line although the message is different.

$ git format-patch -1 --stdout | scripts/checkpatch.pl -
Sequence (?-1...) not recognized in regex; marked by <-- HERE in 
m/(\((?:(?>[^\(\)]+)|(?-1 <-- HERE ))*\))/ at scripts/checkpatch.pl line 
347.

> ---
>   scripts/checkpatch.pl | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b28cc38..fb53845 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -344,7 +344,7 @@ our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
>   # requires at least perl version v5.10.0

Anyway, I will try to meet this requirement instead of chasing this. 
Thanks for looking into this.

Regards,
Arend

