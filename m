Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaDQPsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:48:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53757 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbaDQPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:48:08 -0400
Date: Thu, 17 Apr 2014 16:47:15 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140417154714.GD30553@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <20140417153638.GA7317@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417153638.GA7317@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Thu, Apr 17, 2014 at 04:36:38PM +0100, Sam Ravnborg wrote:
> On Thu, Apr 17, 2014 at 02:44:03PM +0100, Will Deacon wrote:
> > Hello,
> > 
> > This RFC series attempts to define a portable (i.e. cross-architecture)
> > definition of the {readX,writeX}_relaxed MMIO accessor functions. These
> > functions are already in widespread use amongst drivers (mainly those supporting
> > devices embedded in ARM SoCs), but lack any well-defined semantics and,
> > subsequently, any portable definitions to allow these drivers to be compiled for
> > other architectures.
> 
> Could this be made in such a way that only architectures that need
> to provide their own versions actually have to add them?
> 
> The current patch-set adds the same dummy defines all over,
> and will put this burden also on new architectures.

It shouldn't be a burden for new architectures, as they will use
asm-generic/io.h and get the definitions from there.

Will
