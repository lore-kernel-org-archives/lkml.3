Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaFSH1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:27:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbaFSH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:27:43 -0400
Message-ID: <53A290EC.1000202@suse.cz>
Date: Thu, 19 Jun 2014 09:27:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: fix errors caused by objtree redefinition
References: <20140619001305.GA24952@birch.djwong.org>
In-Reply-To: <20140619001305.GA24952@birch.djwong.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-19 02:13, Darrick J. Wong wrote:
> In commit 7e1c04779efd51154baf652e653ceb24ce68939b ("kbuild: Use
> relative path for $(objtree)"), objtree was redefined from whatever
> $(CURDIR) is to a simple ".".  Unfortunately, this breaks builddeb,
> which was relying on $objtree to be an absolute path, not a relative
> one.  Since the script is run from the object directory, pick up a
> more absolute value for objtree where it's needed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scripts/package/builddeb |    1 +
>  1 file changed, 1 insertion(+)

Hi Darrick,

thanks for the patch. Can you check if commit a765a7ce from linux-next
also fixes your issue? This is on its way to Linus.

Thanks,
Michal
