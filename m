Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaGUCuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:50:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56876 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaGUCuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:50:18 -0400
Message-ID: <1405911010.6083.3.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 4/7] firmware_class: perform new LSM checks
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 20 Jul 2014 22:50:10 -0400
In-Reply-To: <alpine.LRH.2.11.1407210938310.30619@namei.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	 <1405373897-31671-5-git-send-email-keescook@chromium.org>
	 <alpine.LRH.2.11.1407181339510.15709@namei.org>
	 <CAGXu5jK5np62pR4f7_qa_LU97hBN8e1hu998=C4ah+Xyv3eYtg@mail.gmail.com>
	 <alpine.LRH.2.11.1407191720160.26264@namei.org>
	 <CAGXu5jLqzgJMCqkfLT2azk3J5jX_hBiguA3wkimv9wu60_+xHA@mail.gmail.com>
	 <alpine.LRH.2.11.1407210938310.30619@namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072102-8236-0000-0000-000003FDE53D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 09:43 +1000, James Morris wrote: 
> On Sat, 19 Jul 2014, Kees Cook wrote:
> 
> [...]
> 
> > With the patch series, the LSM hook sees the userspace-touching loads:
> > - from kernel built-in: no LSM hook (nonsense to check the static list)
> > - direct from filesystem: called with file struct
> > - via uevent /sys "loading"/"data" interface: called with NULL file struct
> > - via uevent /sys "fd" interface: called with file struct
> 
> Thanks for the overview.  Can we get this documented in the LSM code?
> 
> > The reason the "fd" interface was added was because otherwise there's
> > no way for systems that use the uevent handler to communicate to the
> > kernel where the bytes being shoved into the "data" interface are
> > coming from.
> 
> Ok.
> 
> I gather folks have also thought about signing firmware?

>From an IMA perspective, this would be the same as for any other file,
just a new hook.

Mimi 

