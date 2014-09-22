Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaIVDJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:09:10 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:65397 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIVDJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:09:08 -0400
MIME-Version: 1.0
In-Reply-To: <1411353090.2952.19.camel@joe-AO725>
References: <1411349544-7479-1-git-send-email-gdonald@gmail.com> <1411353090.2952.19.camel@joe-AO725>
From: Greg Donald <gdonald@gmail.com>
Date: Sun, 21 Sep 2014 22:08:47 -0500
Message-ID: <CAO+WgCb0V1NDwYDmn3dVTGUM6d-D8ptUEeABqe-+7QwxLhMM0w@mail.gmail.com>
Subject: Re: [PATCH] scripts: checkpatch.pl: Fix existing typedef false
 positive warning
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 9:31 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2014-09-21 at 20:32 -0500, Greg Donald wrote:
>> Fixing an "open brace '{' following struct go on the same line" error causes a
>> false positive warning "do not add new typedefs". Fix existing typedef false
>> positive warning.
>
> This doesn't work.
> The matching deleted line can be any number of lines above.

But this fixes the most common case:

-typedef struct ksock_proto
-{
+typedef struct ksock_proto {

If you're wanting to check more than just $rawlines[$linenr - 3], how
far above does it make sense to go?  From what I'm seeing the '{' is
usually on the next line.


-- 
Greg Donald
