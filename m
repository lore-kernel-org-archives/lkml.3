Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3LXSxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 13:53:31 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:46444 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3LXSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 13:53:29 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131222174713.GA3931@gmail.com>
References: <20131222174713.GA3931@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: iio_utils.h bug?
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 24 Dec 2013 18:53:26 +0000
To: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <244177bb-694e-4176-9a42-afae241fc27c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Zubair Lutfullah :" <zubair.lutfullah@gmail.com> wrote:
>Hi,
>
>A guy posted this fix on my blog. I couldn't make sense of it.
>
>Thought I'd post it here. I'll send a proper patch file if 
>I knew what commit log I needed to write.
>And I can't exactly sign-off :s.
Yes you can. Patch routed through you, hence your sign is entirely correct. If you have an email address for the author then the from field can be different from the sign-off and you can add a reported-by as well to credit it as fully as possible.

Will be the weekend at least before I actually look at the code!
>
>I asked him to post but he couldn't/wouldn't.
>
>Regards
>ZubairLK
>
>
>"Defend against buffer overflow of ci_array:
>
> code always overwrites one entry beyond end of array, now fixed
>--Craig Markwardt"
>
>iio_utils.h
>
>@@ -335,6 +335,7 @@ inline int build_channel_array(const char
>*device_dir,
>   while (ent = readdir(dp), ent != NULL) {
>     if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
>          "_en") == 0) {
>+      int current_enabled = 0;
>       current = &(*ci_array)[count++];
>       ret = asprintf(&filename,
>                "%s/%s", scan_el_dir, ent->d_name);
>       if (ret < 0) {
>         ret = -ENOMEM;
>         /* decrement count to avoid freeing name */
>         count--;
>         goto error_cleanup_array;
>       }
>
>       sysfsfp = fopen(filename, "r");
>
>       if (sysfsfp == NULL) {
>         free(filename);
>         ret = -errno;
>         goto error_cleanup_array;
>       }
>
>-      fscanf(sysfsfp, "%u", &current->enabled);
>+      fscanf(sysfsfp, "%u", &current_enabled);
>       fclose(sysfsfp);
>
>-      if (!current->enabled) {
>+      if (!current_enabled) {
>         free(filename);
>         count--;
>         continue;
>       }
>+      current->enabled = current_enabled;
>       current->scale = 1.0;
>       current->offset = 0;
>       current->name = strndup(ent->d_name,

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
