Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3IKBov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:44:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab3IKBou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:44:50 -0400
Date: Tue, 10 Sep 2013 18:44:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130911014443.GA20996@infradead.org>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <522D3153.5000102@roeck-us.net>
 <20130909023152.GA5329@kroah.com>
 <522D32F6.4020705@roeck-us.net>
 <20130909050147.GA3899@osiris>
 <CA+a=Yy6h0y=J9-NQ6LQ8fkWxqQnTQKxAt2+Pr3fSwLQ1hefGsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy6h0y=J9-NQ6LQ8fkWxqQnTQKxAt2+Pr3fSwLQ1hefGsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:14:11AM +0800, Peng Tao wrote:
> The problem is access_process_vm() is not exported since certain
> version of kernel including the latest. According to Christoph in the
> other mail, access_process_vm() is also a core mm function that is not
> supposed to be exported. Then what kind of change shall we make in
> order to keep current functionality?

You should remove the higher level functionality, kernel modules are
not supposed to look at userspace environment variables.

