Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbbAZVBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:01:00 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:44745 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbbAZVA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:00:57 -0500
Date: Tue, 27 Jan 2015 00:00:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150126210054.GG651@moon>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126124731.GA26916@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 02:47:31PM +0200, Kirill A. Shutemov wrote:
> On Fri, Jan 23, 2015 at 07:15:44PM -0800, Calvin Owens wrote:
> > Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
> > is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
> > is very useful for enumerating the files mapped into a process when
> > the more verbose information in /proc/<pid>/maps is not needed.
> > 
> > This patch moves the folder out from behind CHECKPOINT_RESTORE, and
> > removes the CAP_SYS_ADMIN restrictions. Following the links requires
> > the ability to ptrace the process in question, so this doesn't allow
> > an attacker to do anything they couldn't already do before.
> > 
> > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> 
> Cc +linux-api@

Looks good to me, thanks! Though I would really appreciate if someone
from security camp take a look as well.
