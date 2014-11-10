Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaKJSRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:17:42 -0500
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:50166 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbaKJSRk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:17:40 -0500
X-ASG-Debug-ID: 1415642204-0769c44b6a4b850001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
X-Barracuda-Apparent-Source-IP: 130.245.126.10
X-Barracuda-RBL-IP: 130.245.126.10
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
X-ASG-Orig-Subj: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Content-Type: text/plain; charset=utf-8
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <20141110090954.GB333@tucsk>
Date: Mon, 10 Nov 2014 12:08:13 -0500
Cc: Jordi Pujol Palomer <jordipujolp@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "A. Wan" <jm@mokwan.com>,
        Patrick Frisch <patrick@mekufemo6lbi9soa.myfritz.net>,
        Aaron Campbell <aaron@arbor.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <376686B7-FF3A-4487-A457-EEA5C110B6F8@fsl.cs.sunysb.edu>
References: <20141107170242.GA333@tucsk> <20141108192723.444cecd2@gmail.com> <20141110090954.GB333@tucsk>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1990.1)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1415642204
X-Barracuda-URL: http://barracuda.fsl.cs.sunysb.edu:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.11438
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed, Miklos, changing layers dynamically is VERY tricky.  Unionfs supports that, but a good amount of its code all over is dedicated to handling dynamic layer changes.  I advise you to avoid supporting this feature for a while, if ever: get a small, functional, working overlayfs first.

I personally never liked the idea of changing layers dynamically: it’s like asking a file system to remain consistent and detect all lower changes when someone goes and hand-edits disk blocks.  Too messy.  The pain of developing and supporting such a feature is much greater than the annoyance to users who have to unmount and remount back their layers to form a new structure.

Cheers,
Erez.

> On Nov 10, 2014, at 4:09 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> As for changing the stacking while the overlayfs is mounted: currently this is
> not supported, the layers specified at the mount time remain there until the
> overlay is unmounted.  Currently there's no possibility to add or remove layers
> in a dynamic way, and it is definitely more tricky to implement than the static
> configuration.
> 
> Thanks,
> Miklos

