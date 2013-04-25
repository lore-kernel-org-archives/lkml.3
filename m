Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab3DYVJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:09:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3DYVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:09:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Subject: Re: [PATCH 15/21] thermal: cooling: avoid uninitialied used gcc warning
Date: Thu, 25 Apr 2013 23:09:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-16-git-send-email-arnd@arndb.de> <CAC-25o_bmrZZ9n10cBE=ewO7Yr+FmgP2JTYJNr1y=V_9BgcyXQ@mail.gmail.com>
In-Reply-To: <CAC-25o_bmrZZ9n10cBE=ewO7Yr+FmgP2JTYJNr1y=V_9BgcyXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304252309.03613.arnd@arndb.de>
X-Provags-ID: V02:K0:lEnyyB35sxfv6sdCx0b0ylL8VPQrMPCsV9/bhG9QwDi
 bgvS5yztEyT6uXLe+Q+xwAutLUkJjRlTnwjTB7IZ+emYgRZ9zK
 zNY31CnHOqsC6ZkBbjeKYqL3xbuKa089+VjwDUqqQxjuUZmhHm
 fUITeWFSC3MgbLG+qNlHkVDkZXYFlraJSwzYqfO+/4w87iXQlW
 bltZmsO2tQjBVl93Bkky2Jzr7estyLTvDo5HeS54V4mW0EoTiD
 59LUml2rRKkw9FGLDOkDSdwmmVbYrW0zd2dfAPueV47xkljWBu
 M1a0Km20QXd1rPeqFzm27BIP7HBhks58mPRpNFh+dImcWpxAZW
 GHic2PdQOl4V/pN2Rgts=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 April 2013, edubezval@gmail.com wrote:
> Rui has merged a patch that removes this bogus compiler warning:
> http://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&amp;id=4469b99743d296e24aefc5f8ed7df1bc9cfbbac8
> 
> Though, as not as elegant as your patch, it does the trick. :-)

Ok, works for me.

Looking at the patch however tells me that it has the potential to hide real
bugs if the code is ever changed to actually do an uninitialized access.
It's not very likely in this case, but I generally recommend not to add
any variables at declaration time unless the initialization is to a
meaningful value that the code later uses.

	Arnd
