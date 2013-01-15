Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3AOPOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:14:30 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54231 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757464Ab3AOPO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:14:28 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 15 Jan 2013 16:14:19 +0100
Subject: RE: [RFCv2 11/11] remoteproc: Support virtio config space.
Thread-Topic: [RFCv2 11/11] remoteproc: Support virtio config space.
Thread-Index: Ac3fIfPDj3MRRW/YTI2W5ZT7V9AEngUD+Gww
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE067@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-12-git-send-email-sjur.brandeland@stericsson.com>
 <20121221022150.GH28692@WorkStation.localnet>
In-Reply-To: <20121221022150.GH28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,

> > +void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
> > +							void *buf, unsigned
> len)
> > +{
> > +	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
> > +	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
> > +	memcpy(buf, cfg + offset, len);
> > +}
> > +
> > +void rproc_virtio_set(struct virtio_device *vdev, unsigned offset,
> > +		      const void *buf, unsigned len)
> > +{
> > +	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
> > +	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
> > +	memcpy(cfg + offset, buf, len);
> >  }
> 
> Perhaps verify the offset and length to avoid overwriting memory?

OK, I'll add checks on size of the config space.

Regards,
Sjur
