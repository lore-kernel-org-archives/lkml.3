Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaLDANO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:13:14 -0500
Received: from ozlabs.org ([103.22.144.67]:34377 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaLDANM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:13:12 -0500
Message-ID: <1417651990.9123.2.camel@concordia>
Subject: Re: [RESEND PATCH] ima: Fix build failure on powerpc when
 TCG_IBMVTPM dependencies are not met
From: Michael Ellerman <mpe@ellerman.id.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, Lo Hon Ching <lo1@us.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, George Wilson <gcwilson@us.ibm.com>
Date: Thu, 04 Dec 2014 11:13:10 +1100
In-Reply-To: <1417618130.10667.102.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1417586690-11521-1-git-send-email-mpe@ellerman.id.au>
	 <1417618130.10667.102.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 09:48 -0500, Mimi Zohar wrote:
> On Wed, 2014-12-03 at 17:04 +1100, Michael Ellerman wrote: 
> > On powerpc we can end up with IMA=y and PPC_PSERIES=n which leads to:
> > 
> >   warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES)
> >   tpm_ibmvtpm.c:(.text+0x14f3e8): undefined reference to `.plpar_hcall_norets'
> > 
> > I'm not sure why IMA needs to select those user-visible symbols, but if
> > it must then the simplest fix is to just express the proper dependencies
> > on the select.
> 
> On systems without a TPM, IMA goes into a "by-pass" mode, which stores
> the measurements without extending the TPM PCR.  On Power, there isn't a
> HW TPM, but on Power running PowerVM there is a virtual TPM(vTPM).  On
> Power running PowerKVM there isn't support for vTPM, yet.  The Kconfig
> needs to differentiate between the two.

No it doesn't. We don't build different configs for guests on PowerVM vs
PowerKVM. The code needs to handle detecting the presence or absence of the
vTPM at runtime.

But none of that relates to this build fix AFAICS.

cheers


