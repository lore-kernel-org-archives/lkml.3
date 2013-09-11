Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3IKNwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3IKNwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:52:06 -0400
Date: Wed, 11 Sep 2013 09:51:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, d.kasatkin@samsung.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH 14/16] kexec: Export sysfs attributes for secureboot and
 secure modules to user space
Message-ID: <20130911135137.GC15364@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-15-git-send-email-vgoyal@redhat.com>
 <CA+5PVA7seT-Au6Qsr-svbG38-ohCUrw2=W6CoO5XWqy2Avjg6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7seT-Au6Qsr-svbG38-ohCUrw2=W6CoO5XWqy2Avjg6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 06:57:55PM -0400, Josh Boyer wrote:

[..]
> > +static ssize_t secureboot_enabled_show(struct kobject *kobj,
> > +                                      struct kobj_attribute *attr, char *buf)
> > +{
> > +       /* TODO: Change it once secureboot patches are in */
> > +       return sprintf(buf, "%d\n", 1);
> > +}
> > +KERNEL_ATTR_RO(secureboot_enabled);
> 
> You're defaulting this to enabled, even on machines where SB isn't
> possible.  I realize there are TODOs there, but you might want to
> default it to off if you really intend this on going upstream before
> any of the other secure_* infrastructure does.

I defaulted it to 1 because I wanted to artificially simulate that
secureboot is enabled and make sure kexec-tools verifies signature
of bzImage.

This is just an RFC series to show what's cooking and get early feedback
about design. I am not expecting any of this to get in before secureboot/
secure_modules/securelevel patches get in.

First some set of patches need to block kexec loading, only then these
patches make sense.

So don't read too much into current default values. Idea is to show
that kernel will export 1-2 knobs to user space which will signal
kexec-tools to verify signature of bzImage and also set "secureboot"
in bootparams for next kernel as needed.

Thanks
Vivek
