Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3JYDY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 23:24:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56838 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3JYDY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 23:24:57 -0400
Date: Fri, 25 Oct 2013 04:24:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: introduce d_instantiate_no_diralias()
Message-ID: <20131025032454.GC13318@ZenIV.linux.org.uk>
References: <20130918121204.GC31733@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918121204.GC31733@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 02:12:04PM +0200, Miklos Szeredi wrote:
> Al,
> 
> This is for next (3.13), could you please ack it or take it through your tree?

Done, with one change: it's doing iput() on failure.  Same pattern as
d_make_root()/d_materialise_unique()/etc - makes for simpler failure exits.
