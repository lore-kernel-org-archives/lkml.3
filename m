Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3GKMF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:05:26 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:38360 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3GKMFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:05:25 -0400
Message-ID: <51DE9F16.3090405@schinagl.nl>
Date: Thu, 11 Jul 2013 14:03:34 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: [PATCH v2 2/7] sysfs.h: add ATTRIBUTE_GROUPS() macro
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-3-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1373502965-1683-3-git-send-email-gregkh@linuxfoundation.org>
Content-Type: multipart/mixed;
 boundary="------------040008060903050105080005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040008060903050105080005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11-07-13 02:36, Greg Kroah-Hartman wrote:
> To make it easier for driver subsystems to work with attribute groups,
> create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
> typing for the most common use for attribute groups.
Forgot to add this trivial little cleanup patch with my previous mail, I 
know you don't like patch dependancies, but this one depends on the 
previous one as that included stat.h, if you decide my previous patch 
isn't good, i can redo this one with stat.h included (and move atomic.h 
to the top to keep includes alphabetically ordered).

Oliver
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   include/linux/sysfs.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 9cd20c8..f62ff01 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -94,6 +94,15 @@ struct attribute_group {
>   #define __ATTR_IGNORE_LOCKDEP	__ATTR
>   #endif
>
> +#define ATTRIBUTE_GROUPS(name)					\
> +static const struct attribute_group name##_group = {		\
> +	.attrs = name##_attrs,					\
> +};								\
> +static const struct attribute_group *name##_groups[] = {	\
> +	&name##_group,						\
> +	NULL,							\
> +}
> +
>   #define attr_name(_attr) (_attr).attr.name
>
>   struct file;
>


--------------040008060903050105080005
Content-Type: text/x-patch;
 name="0001-sysfs-use-file-mode-defines-from-stat.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-sysfs-use-file-mode-defines-from-stat.h.patch"

>From a67de9f026363ce821c72a807d98830abece3cf7 Mon Sep 17 00:00:00 2001
From: Oliver Schinagl <oliver@schinagl.nl>
Date: Thu, 11 Jul 2013 13:57:42 +0200
Subject: [PATCH] sysfs: use file mode defines from stat.h

With the last patches stat.h was included to the header, and thus those
permission defines should be used.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 include/linux/sysfs.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 0ebed11..8f820c7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -69,18 +69,19 @@ struct attribute_group {
  * for examples..
  */
 
-#define __ATTR(_name,_mode,_show,_store) { \
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show	= _show,					\
-	.store	= _store,					\
+#define __ATTR(_name,_mode,_show,_store) { 				\
+	.attr = {.name = __stringify(_name), .mode = _mode },		\
+	.show	= _show,						\
+	.store	= _store,						\
 }
 
-#define __ATTR_RO(_name) { \
-	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
-	.show	= _name##_show,					\
+#define __ATTR_RO(_name) {						\
+	.attr	= { .name = __stringify(_name), .mode = S_IRUGO },	\
+	.show	= _name##_show,						\
 }
 
-#define __ATTR_RW(_name) __ATTR(_name, 0644, _name##_show, _name##_store)
+#define __ATTR_RW(_name) __ATTR(_name, (S_IWUSR | S_IRUGO),		\
+			 _name##_show, _name##_store)
 
 #define __ATTR_NULL { .attr = { .name = NULL } }
 
-- 
1.8.1.5


--------------040008060903050105080005--
