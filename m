Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaL3MOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:14:35 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaL3MOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:14:34 -0500
Date: Tue, 30 Dec 2014 04:14:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>
Subject: Re: esp_scsi: make number of tags configurable
Message-ID: <20141230121428.GE32187@infradead.org>
References: <20141209053657.75D6A66095A@gitolite.kernel.org>
 <CAMuHMdXEy6Z4=2off-Y74R6GgKAPnYWwKFTji7ebPE74fddRkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXEy6Z4=2off-Y74R6GgKAPnYWwKFTji7ebPE74fddRkA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:16:47AM +0100, Geert Uytterhoeven wrote:
> > --- a/drivers/scsi/esp_scsi.c
> > +++ b/drivers/scsi/esp_scsi.c
> > @@ -2317,6 +2317,10 @@ int scsi_esp_register(struct esp *esp, struct device *dev)
> >         static int instance;
> >         int err;
> >
> > +       if (!esp->num_tags)
> > +               esp->num_tags = ESP_DEFAULT_TAGS;
> > +       else if (esp->num_tags >= ESP_MAX_TAG)
> 
> drivers/scsi/esp_scsi.c: In function ???scsi_esp_register???:
> drivers/scsi/esp_scsi.c:2399: warning: comparison is always false due
> to limited range of data type
> 
> ESP_MAX_TAG is 256, num_tags is u8.

Can you send me a patch to just remove that conditional?

