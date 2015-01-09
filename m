Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbbAIMe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:34:26 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:54597 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755AbbAIMeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:34:22 -0500
Date: Fri, 9 Jan 2015 14:33:53 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dominique Martinet <dominique.martinet@cea.fr>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/9p: Initialize status in v9fs_file_do_lock.
Message-ID: <20150109123353.GA24928@node.dhcp.inet.fi>
References: <1420804567-15371-1-git-send-email-dominique.martinet@cea.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420804567-15371-1-git-send-email-dominique.martinet@cea.fr>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 12:56:07PM +0100, Dominique Martinet wrote:
> If p9_client_lock_dotl returns an error, status is possibly never filled
> but will be used in the following switch.
> Initializing it to P9_LOCK_ERROR makes sur we will return an error and
> cleanup (and not hit the default case).

That's what my patch[1] fixes.

http://marc.info/?i=1419858019-116944-1-git-send-email-kirill.shutemov%40linux.intel.com

-- 
 Kirill A. Shutemov
