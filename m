Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaLJKQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:16:51 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:37679 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaLJKQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:16:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141209053657.75D6A66095A@gitolite.kernel.org>
References: <20141209053657.75D6A66095A@gitolite.kernel.org>
Date: Wed, 10 Dec 2014 11:16:47 +0100
X-Google-Sender-Auth: A-5q6Je3Vher8qPjudce2TI5TH0
Message-ID: <CAMuHMdXEy6Z4=2off-Y74R6GgKAPnYWwKFTji7ebPE74fddRkA@mail.gmail.com>
Subject: Re: esp_scsi: make number of tags configurable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 6:36 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=3707a186c8970e3c4f3c8d9ccf4230b8657e919f
> Commit:     3707a186c8970e3c4f3c8d9ccf4230b8657e919f
> Parent:     a87bf29362c763cf35faa17154b699471a8b902e
> Refname:    refs/heads/master
> Author:     Hannes Reinecke <hare@suse.de>
> AuthorDate: Mon Nov 24 15:37:20 2014 +0100
> Committer:  Christoph Hellwig <hch@lst.de>
> CommitDate: Mon Nov 24 16:10:23 2014 +0100
>
>     esp_scsi: make number of tags configurable
>
>     Add a field 'num_tags' to the esp structure to allow drivers
>     to overwrite the number of avialable tags if required.
>     Default is ESP_DEFAULT_TAGS.
>
>     Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>     Acked-by: David S. Miller <davem@davemloft.net>
>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/esp_scsi.c | 12 ++++++------
>  drivers/scsi/esp_scsi.h |  3 +--
>  2 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 7e7687f..57ccb14 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2317,6 +2317,10 @@ int scsi_esp_register(struct esp *esp, struct device *dev)
>         static int instance;
>         int err;
>
> +       if (!esp->num_tags)
> +               esp->num_tags = ESP_DEFAULT_TAGS;
> +       else if (esp->num_tags >= ESP_MAX_TAG)

drivers/scsi/esp_scsi.c: In function ‘scsi_esp_register’:
drivers/scsi/esp_scsi.c:2399: warning: comparison is always false due
to limited range of data type

ESP_MAX_TAG is 256, num_tags is u8.

> +               esp->num_tags = ESP_MAX_TAG - 1;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
