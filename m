Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbaFRX6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:58:53 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38366 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaFRX6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <1719649.5PAcuqR8Pm@sifl>
References: <1402762742-2808-1-git-send-email-namhyung@kernel.org> <1719649.5PAcuqR8Pm@sifl>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 19 Jun 2014 08:58:31 +0900
X-Google-Sender-Auth: xO_hiGXsnE2kAPTZCVcl5vGO-Qc
Message-ID: <CAM9d7cj07=ERVUnEhpCu6g72HsXCFSFmha8U6BZL6BbYBxckEg@mail.gmail.com>
Subject: Re: [PATCH 1/2] selinux: simple cleanup for cond_read_node()
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        selinux@tycho.nsa.gov, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Jun 19, 2014 at 4:36 AM, Paul Moore <paul@paul-moore.com> wrote:
> > @@ -402,19 +402,14 @@ static int cond_read_node(struct policydb *p, struct
>> cond_node *node, void *fp) int rc;
>>       struct cond_expr *expr = NULL, *last = NULL;
>>
>> -     rc = next_entry(buf, fp, sizeof(u32));
>> +     rc = next_entry(buf, fp, sizeof(buf));
>
> This is a bit nit-picky, but how about using "sizeof(u32) * 2"?  It is more
> consistent with the rest of the function and helps underscore that we are
> reading two 32-bit values.
>
> Assuming you're okay with the change I can fix it up when I apply the patch.

I'm okay with it. :)

Thanks,
Namhyung
