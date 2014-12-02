Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbaLBVUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:20:13 -0500
Received: from ozlabs.org ([103.22.144.67]:51547 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbaLBVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:20:12 -0500
Date: Wed, 3 Dec 2014 08:20:08 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter =?UTF-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>
Cc: "Hon Ching (Vicky) Lo" <honclo@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if
 driver_data is bad
Message-ID: <20141203082008.6c7ed94b@kryten>
In-Reply-To: <201412022139.58754.PeterHuewe@gmx.de>
References: <20140920072942.27c28768@kryten>
	<201412022139.58754.PeterHuewe@gmx.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> is this patchset still needed after Vicky's patch 
> "[tpmdd-devel] Fix NULL return in tpm_ibmvtpm_get_desired_dma"
> https://patchwork.ozlabs.org/patch/402315/
> 
> Ashley raised some concerns.
> 
> Since merge window is coming up, a fast reply is appreciated.

We definitely need a way to catch an invalid driver data pointer, but it
looks like that needs to be reworked after Vicky's patch.

Vicky could you look at all uses of ibmvtpm_get_data and make
sure we don't blindly dereference it? eg:

static int tpm_ibmvtpm_resume(struct device *dev)
{
        struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
...

                rc = plpar_hcall_norets(H_ENABLE_CRQ,
                                        ibmvtpm->vdev->unit_address);

Anton
