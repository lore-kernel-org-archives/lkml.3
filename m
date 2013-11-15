Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3KOMMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:12:12 -0500
Received: from mail.southpole.se ([37.247.8.11]:45861 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3KOML6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:11:58 -0500
Message-ID: <52860FC1.6050500@southpole.se>
Date: Fri, 15 Nov 2013 13:12:49 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olof Kindgren <olof.kindgren@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>, linux <linux@openrisc.net>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org> <5285EE5A.1070202@southpole.se> <CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com> <5285FE1D.3020800@southpole.se> <CAKaYPCNqzYcSyTUjjb9H3naErjzqjLDBthE2xfQ98j-YOzQWwg@mail.gmail.com>
In-Reply-To: <CAKaYPCNqzYcSyTUjjb9H3naErjzqjLDBthE2xfQ98j-YOzQWwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 17514-10313
X-Assp-Session: B709D10 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 12:39 PM, Olof Kindgren wrote:
> 2013/11/15 Jonas Bonn <jonas@southpole.se>
>
>> On 11/15/2013 11:22 AM, Geert Uytterhoeven wrote:
>>
>>> This should probably be "altera,de0_nano".  We also need to put a version
>>>>
>>>
>>> "terasic,de0_nano"? The board says "Designed and manufactured by Terasic".
>>> Hmm, the sticker on the box says "Altera DE0-Nano".
>>>
>>
>> Good question...
>>
>>
>>
> terasic makes more sense than Altera. Altera just provides one of the
> components on the board

OK, terasic is probably better then.

>
>
>>
>>>> Version number needed.  OpenCores wanted "projectname-rtlsvn###" where
>>>> ###
>>>> is the SVN commit number of the RTL directory in the project's source
>>>> repository.
>>>>
>>>
>>> That's gonna need some information diving, as Stefan's orpsoc git
>>> repositories
>>> only contains references to orpsocv2 git-svn-ids, not the svn ids of
>>> the original
>>> component repositories.
>>>
>>
>> Stefan?  Where's the "official" home of these cores nowadays?  Have they
>> been modified since they were copied from OpenCores into orpsocv2?
>>
>>
> Most cores are fetched directly from OpenCores SVN. Out of these, some are
> patched on the fly by ORPSoC before they are being built. Most of the new
> cores are only available on github

The version number is important in order to ensure _driver_ 
compatibility.  As long as the patches don't make changes that requires 
changes to the Linux driver then it's OK to just put the SVN version 
number on them.  If incompatible changes are being made, then we really 
need to find a "home" for these cores so that we can manage their 
version numbers in some way.

>
> More generally, can Linux use out-of-tree DTS files in an easy way? It's
> handy to have them in the kernel, but the best fit might actually be to put
> them in the corresponding orpsocv3 system directory. That would also make
> it easier to have separate device trees for differently configured FPGAs
> (they are reprogrammable after all).

Yes, the DTS files don't really belong in the kernel tree at all.  They 
belong "near the hardware".  For these FPGA projects it definitely makes 
sense to keep (or automatically generate) the DTS files in the RTL build 
system, i.e. orpsoc.

We generally build the DTB into the kernel image itself, but that's not 
really necessary.  You just need to get the DTB into memory and pass the 
kernel a pointer to it.  If you can find some way to build the DTB into 
the FPGA image (block RAM?) then you've got a self-describing HW image: 
  have the OpenRISC core initialize itself with r3 containing the 
address of the DTB and jump to the kernel entry point (reset vector) and 
everything should just work.  If you put device tree logic into newlib 
as well then you can use this HW description for (other) bare metal 
apps, as well.

The device tree compiler is in the Linux kernel tree... but it's usable 
outside of the Linux build system, as well.  You'll find the binary in 
script/dtc/dtc in the kernel tree... run it with --help to get an idea 
of how it's used.  It really isn't supposed to have anything to do with 
Linux at all; it's a generic tool for a generic HW description.

/Jonas


>
>
> //Olof
>
