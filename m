Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3GZAgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:36:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58324 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab3GZAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:36:31 -0400
Message-ID: <51F1C48C.7010408@wwwdotorg.org>
Date: Thu, 25 Jul 2013 17:36:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Jason Cooper <jason@lakedaemon.net>, Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com> <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com> <20130725193135.GT23879@titan.lakedaemon.net> <CAL_Jsq+vWbTb8wNEDCR2c_M6sBnKW6e5HGk48QzmXSujQUdddA@mail.gmail.com> <20130725203228.GX23879@titan.lakedaemon.net> <20130725215315.GV7729@decadent.org.uk>
In-Reply-To: <20130725215315.GV7729@decadent.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 02:53 PM, Ben Hutchings wrote:
> On Thu, Jul 25, 2013 at 04:32:28PM -0400, Jason Cooper wrote:
> [...]
>> One of the things I've been trying to square up in my head is how to
>> retain the history of the binding when moving to the new tree.  My
>> current idea was to clone the kernel tree, add one patch deleting
>> everything but the bindings and dts files, and one more patch moving
>> things where we want them (arch/{powerpc,arm}/boot/dts -> dts).
>>
>> Then, as needed, we could merge a kernel version tag and delete
>> everything we don't need (code) in the merge commit.
>>
>> The downside of this is it would be messy, the upside is that we could
>> closely track the kernel tree (until the bindings and dts are moved
>> out), and retain the history of the bindings and dts files.
> [...]
> 
> It's *extremely* messy, but 'git filter-branch' might help to make a
> clean tracking branch preserving history of just DT files.  David
> Woodhouse did something like that for the linux-firmware repo
> initially.

Ian Campbell is already working on exactly this solution:
https://lkml.org/lkml/2013/7/23/547

