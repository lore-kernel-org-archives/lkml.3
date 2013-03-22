Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3CVTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:15:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3CVTPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:15:06 -0400
Date: Fri, 22 Mar 2013 12:14:56 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] nfsd: fix bad offset use
Message-ID: <20130322191456.GU10038@lenny.home.zabbo.net>
References: <1363976304-26093-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363976304-26093-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 11:18:24AM -0700, Kent Overstreet wrote:
> vfs_writev() updates the offset argument - but the code then passes the
> offset to vfs_fsync_range(). Since offset now points to the offset after
> what was just written, this is probably not what was intended

Agreed, the original code does look fishy and this fix right to me.

Reviewed-by: Zach Brown <zab@redhat.com> 

- z
