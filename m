Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaGTXqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 19:46:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:34019 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaGTXqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 19:46:14 -0400
Date: Mon, 21 Jul 2014 09:43:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] firmware_class: perform new LSM checks
In-Reply-To: <CAGXu5jLqzgJMCqkfLT2azk3J5jX_hBiguA3wkimv9wu60_+xHA@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1407210938310.30619@namei.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org> <1405373897-31671-5-git-send-email-keescook@chromium.org> <alpine.LRH.2.11.1407181339510.15709@namei.org> <CAGXu5jK5np62pR4f7_qa_LU97hBN8e1hu998=C4ah+Xyv3eYtg@mail.gmail.com>
 <alpine.LRH.2.11.1407191720160.26264@namei.org> <CAGXu5jLqzgJMCqkfLT2azk3J5jX_hBiguA3wkimv9wu60_+xHA@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Kees Cook wrote:

[...]

> With the patch series, the LSM hook sees the userspace-touching loads:
> - from kernel built-in: no LSM hook (nonsense to check the static list)
> - direct from filesystem: called with file struct
> - via uevent /sys "loading"/"data" interface: called with NULL file struct
> - via uevent /sys "fd" interface: called with file struct

Thanks for the overview.  Can we get this documented in the LSM code?

> The reason the "fd" interface was added was because otherwise there's
> no way for systems that use the uevent handler to communicate to the
> kernel where the bytes being shoved into the "data" interface are
> coming from.

Ok.

I gather folks have also thought about signing firmware?


-- 
James Morris
<jmorris@namei.org>

