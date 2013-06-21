Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438Ab3FUNZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:25:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216Ab3FUNZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:25:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH] char: misc: assign file->private_data in all cases
Date: Fri, 21 Jun 2013 15:25:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>,
        michael.opdenacker@free-electrons.com,
        gregory.clement@free-electrons.com, maxime.ripard@free-electrons.com,
        alexandre.belloni@free-electrons.com
References: <1371819665-3882-1-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1371819665-3882-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211525.06761.arnd@arndb.de>
X-Provags-ID: V02:K0:9lLTvkuRVtOcuPSUA08V3HJZTRRZg6MR16a3g5mU8Gp
 6Xh1xd4BMyrMJbLZV5sKa5dn6h+S1UjF17pHvt+mRuZNJAytRe
 M2mMMm8ZHpPI1DoFvqWoMF02gxQ12ipexGoYEF7IWtASZpKiaY
 fBiCXfrQQRHIXFwdVSA8U1k2tLOhOPYtTsWfoaIQnqWqVQNmGZ
 SCJka/lsnaBDU3XME+Bf2+eY/BBuJXd97Ce+EAkwSbonUBUub6
 nY+yHbYj8gUnaiscPSw9dg4ZWo93wVdCxOGz+X+oMtClWNTkm5
 5X4+58bwp8YpqhooL8Vs9/I+JKe9RxV+03s1ojfxVh1ArOTv0F
 Aa8DgwB0Y6IbrCRo4wC8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Thomas Petazzoni wrote:
> n fa1f68db6ca ("drivers: misc: pass miscdevice pointer via file
> private data"), the misc driver infrastructure was changed to assigned
> file->private_data as a pointer to the 'struct miscdevice' that
> corresponds to the device being opened.
> 
> However, this assignment was only done when the misc driver was
> declaring a driver-specific ->open() operation in its
> file_operations. This doesn't make sense, as the driver may not
> necessarily have a custom ->open() operation, and might still be
> interested in having file->private_data properly set for use in its
> ->read() and write() operations.
> 
> Therefore, we move the assignment of file->private_data outside of the
> condition that tests whether a driver-specific ->open() operation was
> defined.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
