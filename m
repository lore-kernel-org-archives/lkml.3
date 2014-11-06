Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaKFQbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:31:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38852 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaKFQbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:31:37 -0500
Date: Thu, 6 Nov 2014 17:31:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, dinguyen@opensource.altera.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv3 4/5] edac: altera: Add Altera L2 Cache and OCRAM EDAC
 Support
Message-ID: <20141106163134.GF4318@pd.tnic>
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
 <1414683131-20786-5-git-send-email-tthayer@opensource.altera.com>
 <20141104151214.GD9570@pd.tnic>
 <545959E8.2040005@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <545959E8.2040005@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thor,

On Tue, Nov 04, 2014 at 04:57:44PM -0600, Thor Thayer wrote:
> We want to at least separate L2/OCRAM ECC from the SDRAM ECC because
> 1) the SDRAM preparation can take almost 2 seconds on boot and some
> customers need a faster boot time.
> 2) the SDRAM has an ECC initialization dependency on the preloader which is
> outside the kernel. It is desirable to be able to turn the SDRAM on & off
> separately.

Well, now that I asked and you gave valid reasons for the split,
you should keep them split the way they are. But please do add that
explanation to the commit message so that it is clear to people why
there is a split.

> You bring up a good point about the L2 and OCRAM being combined though.
> 
> If we do want granular control, maybe I should use a submenu? Or isn't that
> desirable either?

Well, what do you think would be easier/faster for a user configuring? A
separate menu where you have to do a couple of key presses just to enter
it or simply a subtree in Kconfig with all the options together. I think
the "depends" gives you that already...

Ok, once you've worked in the suggested changes, you're good to go,
at least for the EDAC bits. Let me know how you want to handle this,
whether I should pick up the whole thing or I should ack the EDAC parts.
This patchset should go together, in any case, and so I don't care
whoever picks it up.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
