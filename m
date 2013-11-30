Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3K3PpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:45:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43731 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3K3PpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:45:06 -0500
Date: Sat, 30 Nov 2013 15:44:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>,
        "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Anurag Aggarwal <a.anurag@samsung.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>
Subject: Re: [PATCH V2] ARM : unwinder : Prevent data abort due to stack
	overflow while executing unwind instructions Signed-off-by: Anurag
	Aggarwal <a.anurag@samsung.com>
Message-ID: <20131130154440.GZ16735@n2100.arm.linux.org.uk>
References: <1385717671-28953-1-git-send-email-a.anurag@samsung.com> <20131129125953.GG4634@e103592.cambridge.arm.com> <CAPoNrttZfHLa9WDJihChbMGNBmdtPa+TOS=HEd2Ro-3hcuVxNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoNrttZfHLa9WDJihChbMGNBmdtPa+TOS=HEd2Ro-3hcuVxNA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 08:39:02PM +0530, Anurag Aggarwal wrote:
> > You can calculate low, high and high - low once and store them in
> > unwind_ctrl_block.  No need to recalculate them every time.
> 
> I don't think it is feasible to store high and low in unwind_ctrl_block,
> we will have to recalculate them every time in this case also as the
> value of sp is which change every time and depending on the value
> of sp the value of high and low will also change.

low may change, but high definitely won't do.  The SP is not allowed to
move outside the 8K page.

Also, please learn to cut text which is not relevant to your reply,
rather than leaving lots of lines of unnecessary quoted text in.
