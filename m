Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3JDWAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:00:34 -0400
Received: from mout.gmx.net ([212.227.17.22]:56820 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3JDWAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:00:19 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs into tpm-sysfs.c
Date: Sat, 5 Oct 2013 00:02:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>,
        Sirrix AG <tpmdd@sirrix.com>
References: <52408E5D.4020904@tycho.nsa.gov> <20131004170803.GB6955@obsidianresearch.com> <524F1450.6060406@linux.vnet.ibm.com>
In-Reply-To: <524F1450.6060406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201310050002.09320.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:sXQopfHkgxLp+ME8w8kthiP9BRAnuhsgozF2Jc7kLNqHEnw6mZY
 nouuSNnJmPwz8FsxusuX2xT14XCCiYHyT6JJzPHuNVjDCo9BdFrGc8ZK0Xrz40wL9uVkBVF
 aBMq1Rof8uGIQO/HhJN9pzYHKfung9O/jhuFmtehFiLIzmps+JOSeWHRTuFW69gIJP3yNQi
 5608N9EL7sY+1TflrC+Zg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Oktober 2013, 21:17:36 schrieb Stefan Berger:
> On 10/04/2013 01:08 PM, Jason Gunthorpe wrote:
> > On Mon, Sep 30, 2013 at 05:09:51PM -0500, Joel Schopp wrote:
> >>> So far, nobody I have talked to has offered any strong opinions on
> >>> what locality should be used or how it should be set. I think finding
> >>> a developer of trousers may be the most useful to talk about how the
> >>> ioctl portion of this would need to be set up - if someone is actually
> >>> needed.
> >> 
> >> I am a TrouSerS developer and am ccing Richard, another TrouSerS
> >> developer, and ccing the trousers-tech list.  It would be good if you
> >> could elaborate on the question and context for those not following the
> >> entire thread, myself included.
> > 
> > Two questions:
> > 
> > Is userspace interested in using the TPM Locality feature, and if so
> > is there any thoughts on what the interface should be?
> 
> In terms of interface it should probably be an ioctl so that whoever
> holds the fd to /dev/tpm0 gets to choose the locality.
> 
> Locality allows the resetting of certain PCRs. See section 3.7 in
> 
> http://www.trustedcomputinggroup.org/files/static_page_files/8E45D739-1A4B-> B294-D06274E7047730FD/TCG_PCClientTPMInterfaceSpecification_TIS__1-3_27_032
> 12013.pdf
> 
> Locality 4 can only be used by the hardware (section 2.2).


Afaik Locality 3 (and sometimes 2) is often also "locked down"/filtered after 
the bios phase.


>From 
http://www.intel.com/content/dam/www/public/us/en/documents/guides/intel-txt-software-development-guide.pdf

"The storage spaces accessible within a TPM device are grouped by a locality 
attribute and are a separate set of address ranges from the Intel TXT Public 
and Private spaces.
The following localities are defined:
Locality 0 : Non trusted and legacy TPM operation
Locality 1 : An environment for use by the Trusted Operating System
Locality 2 : Trusted OS
Locality 3 : Authenticated Code Module
Locality 4 : Intel TXT hardware use only"

(I know that's "only" Intel's view and not a TCG spec)

Thanks,
Peter
