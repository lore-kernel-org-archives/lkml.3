Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbaLBTks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:40:48 -0500
Received: from mout.gmx.net ([212.227.15.15]:59673 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056AbaLBTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:40:41 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Ashley Lai <ashley@ashleylai.com>
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if driver_data is bad
Date: Tue, 2 Dec 2014 20:46:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Anton Blanchard <anton@samba.org>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20140920072942.27c28768@kryten> <alpine.DEB.2.10.1412021307180.15589@ant>
In-Reply-To: <alpine.DEB.2.10.1412021307180.15589@ant>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201412022046.04376.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:1uXLVbFD4I/G39Jy1nHh8H6gI0k6ouWhrwJk47OARwsj1328NDG
 CAlQACCeLEdGQjfPid/35bYZUnMQAYwmbtY8yDGKQQVLthnIqjHlhsoClGh0I6IRi/RBaZn
 nusLFOxjv4ZwX8VPGAiUZ/0Cc/8VPDHVheApVxz2Ki8yHW81/8c4iFH5p44h3PqMDxcK8sl
 ayr+eKfxzUhtye/3I42HQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so shall I apply this patch? or not?

Thanks,
Peter

Am Dienstag, 2. Dezember 2014, 20:22:35 schrieb Ashley Lai:
> > @@ -63,9 +63,9 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64
> > w1, u64 w2) static struct ibmvtpm_dev *ibmvtpm_get_data(const struct
> > device *dev) {
> > 
> > 	struct tpm_chip *chip = dev_get_drvdata(dev);
> > 
> > -	if (chip)
> > -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> > -	return NULL;
> > +
> > +	BUG_ON(!chip);
> 
> With the recent patch from Vicky, it is possible to have a NULL value for
> chip which will trigger a false positive for BUG_ON(!chip).
> 
> > +	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> > }
> > 
> > /**

