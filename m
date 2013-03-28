Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3C1PEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:04:09 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61317 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3C1PEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:04:07 -0400
Message-ID: <51545BE4.9050206@gmail.com>
Date: Thu, 28 Mar 2013 10:04:04 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg>
In-Reply-To: <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 09:51 AM, Nicolas Pitre wrote:
> On Thu, 28 Mar 2013, Stefano Stabellini wrote:
> 
>> - the interface to bring up secondary cpus is different and based on
>> PSCI, in fact Xen is going to add a PSCI node to the device tree so that
>> Dom0 can use it.
>>
>> Oh wait, Dom0 is not going to use the PSCI interface even if the node is
>> present on device tree because it's going to prefer the platform smp_ops
>> instead.
> 
> Waitaminute...  I must have missed this part.
> 
> Who said platform specific methods must be used in preference to PSCI?

I did. Specifically, I said the platform should be allowed to provide
its own smp_ops. A platform may need to do addtional things on top of
PSCI for example.

> If DT does provide PSCI description, then PSCI should be used.  Doing 
> otherwise is senseless.  If PSCI is not to be used, then it should not 
> be present in DT.

You can't assume the DT and kernel are in-sync. For example, I've added
PSCI in the firmware and DTB (part of the firmware), but the highbank
kernel may or may not use it depending if I convert it.

Rob

> 
> 
> Nicolas
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

