Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaJVRT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:19:59 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41082 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751899AbaJVRT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:19:57 -0400
Date: Wed, 22 Oct 2014 18:19:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        stefano.stabellini@eu.citrix.com, ezequiel.garcia@free-electrons.com,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Message-ID: <20141022171942.GC27405@n2100.arm.linux.org.uk>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
 <20141022161155.GB27405@n2100.arm.linux.org.uk>
 <CANLsYkwGtB0=VDFa-p11AGFA1XLjgGQGLa-U4WYtSs7-pHtVdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkwGtB0=VDFa-p11AGFA1XLjgGQGLa-U4WYtSs7-pHtVdw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 06:22:09PM +0200, Mathieu Poirier wrote:
> I had this conversation with a colleague who reviewed the work.  If
> the architecture is < 5 the __raw_ versions aren't included and the
> compiler won't complain until someone tries to use the macros.  We
> achieve the same result - the macros aren't accessible when the
> architecture doesn't support it - while saving an #if condition in the
> file.
> 
> I'm not strongly opinionated on this - I can enclose the macros in an
> #if statement.

What you're missing is that some driver may test for their presence by
doing:

#ifndef readq_relaxed
... do something else

which would now break as a detection method, as the macro is always
defined no matter whether it's present or not.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
