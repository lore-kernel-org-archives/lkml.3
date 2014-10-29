Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbaJ2ULt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:11:49 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:41338 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaJ2ULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:11:48 -0400
MIME-Version: 1.0
X-Originating-IP: [92.2.100.198]
In-Reply-To: <1414594338-14695-1-git-send-email-richard@nod.at>
References: <1414594338-14695-1-git-send-email-richard@nod.at>
Date: Wed, 29 Oct 2014 20:11:48 +0000
Message-ID: <CAPcvp5HBnuAHTwFHLJ1Ve6o2MSeQ8Qnn6x7Q0wD2G-yP6p7OLA@mail.gmail.com>
Subject: Re: [PATCH 1/2] UBI: Implement UBI_METAONLY
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 14:52, Richard Weinberger <richard@nod.at> wrote:
> diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
> index c3918a0..82b693f 100644
> --- a/include/linux/mtd/ubi.h
> +++ b/include/linux/mtd/ubi.h
> @@ -34,11 +34,13 @@
>   * UBI_READONLY: read-only mode
>   * UBI_READWRITE: read-write mode
>   * UBI_EXCLUSIVE: exclusive mode
> + * UBI_METAONLY: modify voulme meta data only

Typo - s/voulme/volume/g

>   */
>  enum {
>         UBI_READONLY = 1,
>         UBI_READWRITE,
> -       UBI_EXCLUSIVE
> +       UBI_EXCLUSIVE,
> +       UBI_METAONLY
>  };
>

Also you may want to add something similar to this:

--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -339,7 +339,7 @@ struct ubi_volume {
 /**
  * struct ubi_volume_desc - UBI volume descriptor returned when it is opened.
  * @vol: reference to the corresponding volume description object
- * @mode: open mode (%UBI_READONLY, %UBI_READWRITE, or %UBI_EXCLUSIVE)
+ * @mode: open mode (%UBI_READONLY, %UBI_READWRITE, %UBI_EXCLUSIVE or
%UBI_METAONLY)
  */
 struct ubi_volume_desc {
        struct ubi_volume *vol;

There is also a similar mention in gluebi.c: 'readers/writes/exclusive'.

Thanks,

Andrew Murray
