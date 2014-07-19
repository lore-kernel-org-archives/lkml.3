Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaGSHWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 03:22:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:33999 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbaGSHWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 03:22:39 -0400
Date: Sat, 19 Jul 2014 17:22:15 +1000 (EST)
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
In-Reply-To: <CAGXu5jK5np62pR4f7_qa_LU97hBN8e1hu998=C4ah+Xyv3eYtg@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1407191720160.26264@namei.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org> <1405373897-31671-5-git-send-email-keescook@chromium.org> <alpine.LRH.2.11.1407181339510.15709@namei.org> <CAGXu5jK5np62pR4f7_qa_LU97hBN8e1hu998=C4ah+Xyv3eYtg@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Kees Cook wrote:

> On Thu, Jul 17, 2014 at 8:41 PM, James Morris <jmorris@namei.org> wrote:
> > On Mon, 14 Jul 2014, Kees Cook wrote:
> >
> >> This attaches LSM hooks to the existing firmware loading interfaces:
> >> filesystem-found firmware and demand-loaded blobs.
> >
> >>  static int fw_get_filesystem_firmware(struct device *device,
> >> @@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
> >>               break;
> >>       case 0:
> >>               if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
> >> +                     if (security_kernel_fw_from_file(NULL, fw_buf->data,
> >> +                                                      fw_buf->size)) {
> >> +                             fw_load_abort(fw_priv);
> >> +                             break;
> >> +                     }
> >> +
> >>                       set_bit(FW_STATUS_DONE, &fw_buf->status);
> >>                       clear_bit(FW_STATUS_LOADING, &fw_buf->status);
> >>
> >>
> >
> > Can you explain the loading store, and what the semantics are for an LSM
> > when a NULL is passed as the file?
> 
> I'm not sure what you mean by "loading store"?

The caller: firmware_loading_store()

> When NULL is passed as the file, it means that the firmware was passes
> a blob, and there is no file backing it:

Where does this blob come from, is cached, built into the kernel, or what?


-- 
James Morris
<jmorris@namei.org>

