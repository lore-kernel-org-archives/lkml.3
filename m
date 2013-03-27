Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3C0RvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:51:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3C0RvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:51:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
Date: Wed, 27 Mar 2013 17:50:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <51531F76.2090200@gmail.com> <20130327170555.GA20990@mudshark.cambridge.arm.com>
In-Reply-To: <20130327170555.GA20990@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303271750.52015.arnd@arndb.de>
X-Provags-ID: V02:K0:IbbDyyhx4roEU8Uo69IRlxopdHOMluqApkVTjx2TCpa
 LiAwO8jEBnRtrW0CPPItwQ/GJvhxZdlJyliLoAotIlUHwav2o6
 I6CQKVnrdT6//kLBypYk6KoVQMKmDw34vU+xKgU/JFdutQgHWk
 MRMjHVw/Fn0IP5kHUyi0RCwfTKS1tiHkhpC9j/Lljj6kfxNbP2
 ilQ4spxwStsL0PJLlWdpEVy2OcoMPXcyUL+/YTcTuX9JVYRlAn
 AyIFsgmfrjKr2JhnV28F/OuUCTRmNJ2SjzetG/eg5EeK8uk5SJ
 IXq62vMGk9xsB+S560vwa2kQ4Bd5eA86CC6VbXNOuQmzYs2JPD
 X7UElPB9YKYJjNt3ir6E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 March 2013, Will Deacon wrote:
> The channel is common, sure, but I wouldn't expect the semantics of each
> call to be identical between firmware implementations (going back to my
> previous examples of CPU IDs and implementation-defined state parameters).
> 
> If a platform happens to have an id-mapping from smp_operations to psci,
> then I still think there should be an indirection in there so that we have
> the flexibility to change the smp_operations if we wish and not give
> platforms the false impression that these two things are equivalent.

I think the only reasonably implementation for psci is if we can assume
that each callback with a specific property name has a well-defined behavior,
and we should mandate that every platform that implements the callbacks
we need for SMP actually implements them according to the spec.

What would be the point of a standard psci interface if the specific
implementation are not required to follow the same semantics?

	Arnd
