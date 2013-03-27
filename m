Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3C0TOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:14:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3C0TOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:14:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
Date: Wed, 27 Mar 2013 19:14:13 +0000
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
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <201303271750.52015.arnd@arndb.de> <20130327181206.GD20990@mudshark.cambridge.arm.com>
In-Reply-To: <20130327181206.GD20990@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303271914.13544.arnd@arndb.de>
X-Provags-ID: V02:K0:S5il1G/MNzF9dqgbqCzxKuytbF4T40MP/YmhRCJXTRn
 JuBf4aZliau6A7jRklnbuFkMU4AxcKI5EkmrGbvWtbWnMSb2V2
 fKvpfdp9XqXA05ieelVTQLmZERqZqrvpU+6BulvF5m8TdENKJ6
 Ld8L3jD2i5tEmYozfJRzfRU7FUqsMlCwAHV9fJuKXXV0Tb+Gvh
 RHMeM5Id0K+OtrYETd7uNS5xD3teWVPPUsZrhDlMCv6TqKrfFp
 h/YYNoMjSj3/vWHPFB0muixWtaRFDMOORto0AqDbgauSBHkvLw
 RIyqbxPNYmOf1J24bfYn9fsVVCEkA8b0Bhk0GQw/Xp7yaYx3/Q
 ijVRC8VHEW7qKFYcUCR4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 March 2013, Will Deacon wrote:
> The interface is standard. The functions have well-defined headers and can
> be called in the same way between implementations. The difference is in the
> semantics of the parameters. For example:
> 
>   int cpu_off(u32 power_state);

I think that is the opposite of well-defined :(

> If you look at the power_state parameter, it's actually a struct (see struct
> psci_power_state) with a u16 id field. The current specification describes
> that field as `This is platform specific, the number is understood by the
> firmware, and used to program the power controller.'.
> 
> So unless we get everybody to agree on the definition of that field, we
> can't blindly plug the interfaces together. Furthermore, there are other
> parameters like this and, as new functions are specified, I would expect
> them to grow.

I think it's expected that there will be vendor specific extensions,
but any interface that is part of the standard has to be completely
specified there, anything else is pure madness.

Perhaps we could extend the device tree binding to add the missing bits,
and pass the values that you are supposed to pass there as properties
of the node, but it would be much more logical to require the interface
to be well-behaved in the first place.

	Arnd
