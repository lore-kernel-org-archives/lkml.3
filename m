Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3IKCab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:30:31 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55437 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IKCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:30:30 -0400
Date: Tue, 10 Sep 2013 19:30:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peng Tao <bergwolf@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130911023026.GA6273@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <522D3153.5000102@roeck-us.net>
 <20130909023152.GA5329@kroah.com>
 <522D32F6.4020705@roeck-us.net>
 <20130909050147.GA3899@osiris>
 <CA+a=Yy6h0y=J9-NQ6LQ8fkWxqQnTQKxAt2+Pr3fSwLQ1hefGsw@mail.gmail.com>
 <20130911014443.GA20996@infradead.org>
 <CA+a=Yy6GFzoBT0Bgz7z5bHZRMdEBJa+txwpCZuxA+mRTch-8mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy6GFzoBT0Bgz7z5bHZRMdEBJa+txwpCZuxA+mRTch-8mA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:25:57AM +0800, Peng Tao wrote:
> On Wed, Sep 11, 2013 at 9:44 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Sep 11, 2013 at 01:14:11AM +0800, Peng Tao wrote:
> >> The problem is access_process_vm() is not exported since certain
> >> version of kernel including the latest. According to Christoph in the
> >> other mail, access_process_vm() is also a core mm function that is not
> >> supposed to be exported. Then what kind of change shall we make in
> >> order to keep current functionality?
> >
> > You should remove the higher level functionality, kernel modules are
> > not supposed to look at userspace environment variables.
> >
> OK. I've looked at the specific case that Lustre uses
> access_process_vm() to get the jobid environment variable and package
> it into the RPC requests to server. However, it turns out that in the
> latest Lustre server code, the jobid in a request is not used
> anywhere. So it looks like we can just get rid of it.
> 
> Andreas, could you please confirm this? Is the jobid an obsolete
> parameter that can be abandoned? Or is there plan to use it somehow in
> the future?
> 
"Plan to use it in the future" is not a reason or argument to keep it today,
especially if it is something you are not supposed to do to start with.
If you ever need it, you should be able to find some other means to
support a similar functionality.

Guenter
