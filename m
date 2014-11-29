Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaK2STL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:19:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33229 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402AbaK2STH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:19:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19sQbnbjaZq49xhMbfY+WD8xQOml4xahxo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7A6CA626B49
Date: Sat, 29 Nov 2014 13:18:53 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, joshc@codeaurora.org,
        johannes.thumshirn@men.de, kheitke@codeaurora.org,
        laurent.pinchart+renesas@ideasonboard.com, geert+renesas@glider.be,
        horms+renesas@verge.net.au, damm@opensource.se, tomi.valkeinen@ti.com,
        mbohan@codeaurora.org, michal.simek@xilinx.com, pawel.moll@arm.com,
        Andrew.Thoelke@arm.com
Subject: Re: [RFC PATCH 0/3] Generic TrustZone Driver in Linux Kernel
Message-ID: <20141129181853.GR22670@titan.lakedaemon.net>
References: <1417187016-7731-1-git-send-email-javier@javigon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1417187016-7731-1-git-send-email-javier@javigon.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Fri, Nov 28, 2014 at 04:03:33PM +0100, Javier González wrote:
> Hi all,
> 
> This set of patches is a first iteration to introduce a generic
> TrustZone driver to the Linux Kernel. Since there is no place to add
> drivers related to secure processors, a new subsystem for secure
> hardware in general (drivers/sechw) is also introduced. TPM is a good
> candidate to me moved here if this change is accepted.
> 
> Today, TrustZone solutions are implementation specific. In user space,
> mobile devices are normally compliant with Global Platform's API
> <http://www.globalplatform.org>. However, there is no common TrustZone
> interface for kernel space, as it exists for Trusted Computing Module
> (TPM). As a result, different TrustZone frameworks use different kernel
> loadable modules to provide the context to communicate with the Trusted
> Execution Environment leveraged by TrustZone's secure world.
> 
> Regarding use cases, TrustZone has traditionally been used for
> offloading secure tasks to the secure world. Examples include banking
> applications, Digital Rights Management (DRM), or specific secure
> solutions. As more and more frameworks enabling TrustZone appear, new
> use cases are starting to emerge: key management, encryption, integrity
> checking, etc. Extreme cases today involve running a RTOS in the secure
> world, or using the secure world toimplement usage control policies
> governing the normal world. The advent of ARMv8 will only expand this
> list.
> 
> This set of patches introduce a generic TrustZone driver for kernel
> space. The first design goal is to be flexible enough as to NOT
> introduce policy regarding the TrustZone interface. In this way, we
> introduce a session-based open/close read/write interface where
> several TrustZone drivers can potentially be used. The design is
> simple and it consist on an interface that different TrustZone drivers
> can implement to communicate with the specific frameworks.
> 
> Major TODO's:
>  * Patch has TODOs, FIXMEs and XXXs that need to be cleaned.
>  * Refactor part of Open Virtualization's driver. Some part are complex
>  * and can be simplified.
>  * Add support for different boards. At the moment only zynq-7000 ZC702
>  is supported. A sepparate patch containing the patch for ZC702 will be
>  sent sepparately - rebasing from 3.8 to 3.17 at the moment.
> 
> Development is taking place at:
> 	https://github.com/TrustZoneGenericDriver/linux-xlnx tz_driver
> At 14.5_trd_tz_driver_generic it can be found the same driver together
> with TEE support for Zynq ZC702 in 3.8
> 
> Since all testing is being done in the Xilinx ZC702 board, using
> Xilinx's Linux tree is convenient. Once the board rebasing to 3.17 is
> completed, development will move to:
> 	https://github.com/TrustZoneGenericDriver/linux
> 
> Feedback regarding the code, the interface, or its placement in
> drivers/sechw is more than welcome. The idea is to refine ths TrustZone
> driver while working on supporting more targets.

Please add me to the Cc: on future revisions.

You don't mention a mailinglist.  Is there one for this project?  Also,
TrustZone is a specious marketing name.  For those of us not actively
working with it, wtf is it in engineering terms?  Apparently it can do
virtualization w/o virtualization extensions?

Wouldn't a lot of the trustworthiness depend on the lack of
vulnerabilities in this API or other communications interfaces?  Can end
users choose to load a different binary (say, OpenVZ) than the DRM that
came with the phone?  How is that handled?  How does this fit into a
trusted boot sequence?

And as GregKH mentioned, this definitely needs some cleanup before
expecting others to spend time reviewing.  If this code is working for
your usecase, perhaps the staging tree might be a better place to
start.

thx,

Jason.
