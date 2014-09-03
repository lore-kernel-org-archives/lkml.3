Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbaICOSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:18:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56199 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbaICOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:18:05 -0400
Message-ID: <1409753878.21827.80.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 7/8] ima: remove usage of filename parameter
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        David Safford <safford@us.ibm.com>,
        Roberto Sassu <roberto.sassu@polito.it>
Date: Wed, 03 Sep 2014 10:17:58 -0400
In-Reply-To: <54071778.8050204@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
	 <33e79df19a7c5347be058864339d7698b0bd167a.1409728712.git.d.kasatkin@samsung.com>
	 <1409750203.21827.71.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <54071778.8050204@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090314-1542-0000-0000-000004804C3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 16:28 +0300, Dmitry Kasatkin wrote: 
> On 03/09/14 16:16, Mimi Zohar wrote:
> > On Wed, 2014-09-03 at 10:20 +0300, Dmitry Kasatkin wrote: 
> >> In all cases except ima_bprm_check() filename was not defined and
> >> ima_d_path() was used to find full path.
> >>
> >> ima_bprm_check() used to select between bprm->interp and bprm->filename.
> >> Following dump demonstrates differences between using filename and interp.
> >>
> >> bprm->filename
> >>  filename: ./foo.sh, pathname: /root/bin/foo.sh
> >>  filename: ./foo.sh, pathname: /bin/dash
> >>
> >> bprm->interp
> >>  filename: ./foo.sh, pathname: /root/bin/foo.sh
> >>  filename: /bin/sh, pathname: /bin/dash
> >>
> >> In both cases pathnames are the same.
> >> This patch removes usage of filename and interp in favor of d_path.
> >>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > Thanks, this has been on my list to do.  My only concern is whether we
> > should be using d_path() or one of the other variants (eg.
> > dentry_path(), d_absolute_path()).  For namespaces, we would want to be
> > able to differentiate the files.
> >
> > Please include in this patch description why d_path(), if it is the
> > case, the best option.
> >
> > thanks,
> 
> Hi,
> 
> Actually as we discussed, we can also in this patch change ima_d_path to
> use d_absolute_path().
> It will work for "chroot" cases and will show real path...
> 
> Should I switch to 'd_absolute_path'?

Yes, please.

> In the case of namespaces, neither d_path nor d_absolute_path works....
> Usage of dentry_path() would eliminate mount tree and requires device
> prefix.
> But it will 'break' clients, reading process measurement list.
> That would require essentially more agreement.

Right, we shouldn't break anything, but define a new template field for
the device or some other info.

Mimi

