Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaA3JR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:17:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaA3JRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:17:25 -0500
Message-ID: <1391067307.11310.3.camel@linux-fkkt.site>
Subject: Re: [PATCH v4] HID: New hid-cp2112 driver
From: Oliver Neukum <oneukum@suse.de>
To: Joe Perches <joe@perches.com>
Cc: David Barksdale <dbarksdale@uplogix.com>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jakub =?ISO-8859-1?Q?K=E1kona?= <kjakub@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1391039165.2422.11.camel@joe-AO722>
References: <1391037975-26253-1-git-send-email-dbarksdale@uplogix.com>
	 <1391039165.2422.11.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jan 2014 08:35:07 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 15:46 -0800, Joe Perches wrote:

> > +static int cp2112_hid_get(struct hid_device *hdev, unsigned char report_number,
> > +			  u8 *data, size_t count, unsigned char report_type)
> > +{
> > +	u8 *buf;
> > +	int ret;
> > +
> > +	buf = kmalloc(count, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	ret = hdev->hid_get_raw_report(hdev, report_number, buf, count,
> > +				       report_type);
> > +	memcpy(data, buf, count);
> > +	kfree(buf);
> > +	return ret;
> 
> if the data is going to be copied in data,
> why not just use data in hid_get_raw_report
> and avoid the malloc?

He must not. It would violate the DMA rules. This function is passed
pointers to parts of structures. Access to the structures may race
with a DMA to/from the buffer. That violates the DMA rules.

	Regards
		Oliver


