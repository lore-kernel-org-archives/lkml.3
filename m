Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3KQIoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 03:44:55 -0500
Received: from mail.southpole.se ([37.247.8.11]:48062 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3KQIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 03:44:49 -0500
Message-ID: <528881F6.3090902@southpole.se>
Date: Sun, 17 Nov 2013 09:44:38 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Olof Kindgren <olof.kindgren@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>, linux <linux@openrisc.net>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>	<5285EE5A.1070202@southpole.se>	<20131116084505.GA26233@chokladfabriken.org> <CAKaYPCNOLbX09Pqx7Zn=ivO++iBZMbBpu-pMjNgayVDBrBX1yQ@mail.gmail.com>
In-Reply-To: <CAKaYPCNOLbX09Pqx7Zn=ivO++iBZMbBpu-pMjNgayVDBrBX1yQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 77879-02061
X-Assp-Session: 7F739B66CA00 (mail 1)
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

I think this discussion is veering away from what's relevant for the 
linux-kernel and devicetree lists and did consider dropping them at this 
point... but let's leave them in the discussion a bit longer in case 
there's some sage guidance to be found there on the topic of doing sane 
versioning of open source hardware.

On 11/16/13 12:01, Olof Kindgren wrote:
> 2013/11/16 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
>> On Fri, Nov 15, 2013 at 10:50:18AM +0100, Jonas Bonn wrote:
>>>> +
>>>> +    i2c0: ocores@a0000000 {
>>>> +            #address-cells = <1>;
>>>> +            #size-cells = <0>;
>>>> +            compatible = "opencores,i2c-ocores";
>>> Version number needed.  OpenCores wanted "projectname-rtlsvn###"
>>> where ### is the SVN commit number of the RTL directory in the
>>> project's source repository.
>>>
>> That will also require a change to the driver.
The drivers in question aren't upstream so it's not a big deal. Making a 
change to get sane revisioning would be worth it anyway.

>>
>> Using svn commit ids as version info seems a bit too fine grained to me,
>> but if that's what's agreed on, then it should be the commit id from the
>> projects official repository at opencores.org I think.
The DTS version tells the driver what feature set it can expect to find 
in the HW core and thus how to go about driving it.  Normally, the core 
won't change features much, but if you add something new you'd want the 
driver to see a new 'compatible' tag so that it knows which features it 
can/should enable.  New features will always entail driver changes; and 
a driver can always be compatible with both the old and new HW versions 
by just enabling the feature set appropriate to the HW in question.

>>
>> Stefan
>> _______________________________________________
>> Linux mailing list
>> Linux@lists.openrisc.net
>> http://lists.openrisc.net/listinfo/linux
>
> I agree. I don't like doing versioning with revision numbers. It's too
> closely tied to the currently used VCS. The problem is that no one has
> bothered to do proper releases of the cores for the last ten years or
> so.
>
> But since we are talking about a relatively small amount of cores
> here, I think it could be worth to take a quick glance to see if the
> latest SVN version is compatible with the latest tagged release. I
> would suspect that is the case for the majority of the cores and the
> we can just use the latest tag as version. For the other cores we
> could
> 1. Use latest tag + 1 (a bit ugly if the maintainer wants to do a proper release
> 2. Take over maintainership/fork and just release what's in the trunk
> (taking over maintenance is preferrable here to avoid  more repo
> confusion)
> 3. Use SVN revisions
>
> option 2 would be my preferred choice here, given that we get someone
> to do the actual work. I could probably help out with a few of the
> cores

My suggestion:
i)  Move the primary source of these cores to git (doesn't matter 
where... github is fine)
ii)  Use a shortened git commit ID (6 chars) as the version number

Why?

i)  The commit ID is independent of the repository; whether the repo is 
opencores, github, or olof's computer, the commit ID is constant
ii)  Tag names are arbitrary labels; they don't contain any more 
information than the commit ID
iii)  The commit ID,  being a hash of the source and repository history 
itself, contains information that makes it effectively impossible for 
someone to attach the same label to an incompatible core
iv)  I think everyone actively working on these cores today are doing so 
via git already... via orpsocv2/3, presumably

NB: you might do named releases of a core, from versions 1.2 to 2.5, but 
if the underlying feature set remains the same and the same driver 
applies then the DTS 'compatible' tag would remain constant across all 
these releases.  This means that the HW feature set is decoupled from 
the arbitrary version numbers that people like to use when doing releases.

> Jonas, you said that opencores wanted projectname-svnversion. Do you
> know where that comes from? My proposal here would conflict with that
It came out of a private conversion I had with Marcus Erlandsson (who 
spoke for OpenCores at the time).  The OpenRISC project hadn't really 
moved on to git back then (as it has today) so it was the best we could 
come up with.

/Jonas
