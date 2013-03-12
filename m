Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3CLFBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:01:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57723 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3CLFBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBCihXorfLcjHxNUcJcm+CxpnDwMgB9kcC+VrN9bTK0Gkg@mail.gmail.com>
References: <1356050997-2688-1-git-send-email-walken@google.com>
	<1356050997-2688-5-git-send-email-walken@google.com>
	<CA+ydwtqD67m9_JLCNwvdP72rko93aTkVgC-aK4TacyyM5DoCTA@mail.gmail.com>
	<20130311160322.830cc6b670fd24faa8366413@linux-foundation.org>
	<20130312002429.GA24360@google.com>
	<CAJd=RBCihXorfLcjHxNUcJcm+CxpnDwMgB9kcC+VrN9bTK0Gkg@mail.gmail.com>
Date: Mon, 11 Mar 2013 22:01:22 -0700
Message-ID: <CANN689H7nvBhe3eTkT-WxG5ZZ-o8S7Hvr=LzKk=mMSY83OEtDw@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm: use mm_populate() for blocking remap_file_pages()
From: Michel Lespinasse <walken@google.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 9:23 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Is it still necessary to populate mm if bail out due
> to a linear mapping encountered?

Yes. mmap_region() doesn't do it on its own, and we want the emulated
linear case to behave similarly to the true nonlinear case.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
