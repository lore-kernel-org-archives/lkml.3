Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaGVTqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:46:25 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:50808
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbaGVTqY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:46:24 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: checkpatch.pl false positive
Thread-Topic: checkpatch.pl false positive
Thread-Index: Ac+l0p1dEM4mg3c7QeOMFGJjrkF2wAASm1IAAA3foQA=
Date: Tue, 22 Jul 2014 19:46:22 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F15117@P3PWEX4MB008.ex4.secureserver.net>
References: <DC148C5AA1CEBA4E87973D432B1C2D8825F13B6F@P3PWEX4MB008.ex4.secureserver.net>
 <1406056988.2755.1.camel@joe-AO725>
In-Reply-To: <1406056988.2755.1.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2014 12:23 PM, Joe Perches wrote:
> On Tue, 2014-07-22 at 17:30 +0000, Hartley Sweeten wrote:
>> Joe,
>> 
>> I think this is a false positive, at least the check message appears
>> incorrect:
>> 
>> CHECK: No space is necessary after a cast
>> #66: FILE: arch/arm/mach-ep93xx/include/mach/platform.h:66:
>> +static inline int crunch_init(void) { return 0; }
>
> Yeah, it's a false positive introduced by -next
> commit 89da401f6cff ("checkpatch: improve "no space after cast" test")
>
> Try this?
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2258497..644c2d5 100755
> --- a/scripts/checkpatch.pl
>+++ b/scripts/checkpatch.pl
> @ @ -2418,7 +2418,7 @@ sub process {
>  			}
>  		}
>  
> -		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
> +		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|{)/) {
> 			if (CHK("SPACING",
> 				"No space is necessary after a cast\n" . $herecurr) &&
>  			    $fix) {

That fixed it.

Thanks,
Hartley


