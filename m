Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaFOBqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 21:46:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51306 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaFOBqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 21:46:13 -0400
Message-ID: <1402796767.2651.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-user] oraphaned keywords in audit log text [was: Re:
 [PATCH] integrity: get comm using lock to avoid race in string] printing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        linux-ima-user <linux-ima-user@lists.sourceforge.net>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2014 21:46:07 -0400
In-Reply-To: <CACE9dm83Kxbc3krVkCR9-Wy1Kq+YpEWRkLdbHDivwcxFtGjYmg@mail.gmail.com>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
	 <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <6292885.20TorKeRiK@x2>
	 <1396462368.20325.26.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1396462716.2608.1.camel@localhost>
	 <1396463260.20325.28.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20140402185250.GB24814@madcap2.tricolour.ca>
	 <20140614000258.GA14900@madcap2.tricolour.ca>
	 <CACE9dm83Kxbc3krVkCR9-Wy1Kq+YpEWRkLdbHDivwcxFtGjYmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061501-3532-0000-0000-0000027B8CBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-14 at 12:43 +0300, Dmitry Kasatkin wrote: 
> On 14 June 2014 03:02, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 14/04/02, Richard Guy Briggs wrote:
> >> On 14/04/02, Mimi Zohar wrote:
> >> > On Wed, 2014-04-02 at 14:18 -0400, Eric Paris wrote:
> >> > > On Wed, 2014-04-02 at 14:12 -0400, Mimi Zohar wrote:
> >> > > > On Wed, 2014-04-02 at 14:00 -0400, Steve Grubb wrote:
> >> > > > > Hello Mimi,
> >> > > > >
> >> > > > > On Wednesday, April 02, 2014 01:39:47 PM Mimi Zohar wrote:
> >> > > > > > This change is already being upstreamed as commit 73a6b44 "Integrity:
> >> > > > > > Pass commname via get_task_comm()".
> >> > > > >
> >> > > > > While I was looking at Richard's patch, I noticed a few places where cause and
> >> > > > > op are logged and the string isn't tied together with a _ or -. These are in
> >> > > > > ima/ima_appraise.c line 383, and ima/ima_policy.c lines 333, 657, and 683. Are
> >> > > > > these fixed upstream? Or should a patch be made?
> >> > > >
> >> > > > Nothing has changed in terms of 'cause' and 'op'.  I would suggest
> >> > > > making the changes in integrity_audit.c: integrity_audit_msg().
> >>
> >> That function could massage incoming text fields and convert spaces to
> >> hyphens or underscores, but I'd assume the right place to do it would be
> >> in the original text.  If you suggest the former, it could just be done
> >> in audit_log_string(), but then grepping the source for error messages
> >> would not be nearly as useful.  Is this what you were suggesting?
> >>
> >> > > The question is actually, do you know of anyone who is expecting the
> >> > > space, instead of a more 'audit standard' - or _ ?  If not, we'll change
> >> > > it.  If so, we'll discuss more   :)
> >> >
> >> > CC'ing linux-ima-user as well.
> >>
> >> Thanks.
> >
> > Was there any response from linux-ima-user?
> >
> >> > Mimi
> >>
> >> - RGB
> >
> 
> Hi,
> 
> I will find this patch and have a look.

As nobody has responded, I would assume it is safe to change.

Mimi

