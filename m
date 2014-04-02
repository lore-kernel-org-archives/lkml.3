Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbaDBA2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:28:22 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57547 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaDBA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140401184916.GA21938@kroah.com>
References: <20140401184916.GA21938@kroah.com>
Date: Tue, 1 Apr 2014 17:28:19 -0700
X-Google-Sender-Auth: FgayGH6-AExZ123Q2a7LGW6iUU0
Message-ID: <CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
Subject: Re: [GIT PULL] USB patches for 3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Loc Ho <lho@apm.com>,
        Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 11:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> USB patches for 3.15-rc1
>
> Here's the big USB pull request for 3.15-rc1.

Hmm. I'm getting this when testing:

  warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))

which looks like AHCI_XGENE doesn't have the proper dependency on OF
(or alternatively PHY_XGENE has an incorrect dependemcy on OF).

According to google it looks like Fengguang reported this on
kbuild-all, but nowhere else.

The actual build then succeeds. But the Kconfig warning is real and
implies that something is seriously wrong wrt the dependencies for
this thing.

It looks like the "select PHY_XGENE" came in through the libata
update, but this USB update actually brought in the "config PHY_XGENE"
and thus this error. Which makes me wonder how this all worked. Why
does that "select PHY_XGENE" exist when apparently it's not needed?

Regardless, there's something broken somewhere.

                  Linus
