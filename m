Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaIEHzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:55:22 -0400
Received: from ozlabs.org ([103.22.144.67]:45621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaIEHzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:55:20 -0400
Message-ID: <1409903718.11359.30.camel@ale.ozlabs.ibm.com>
Subject: [PATCH v2] deb-pkg: Add support for powerpc little endian
From: Michael Neuling <mikey@neuling.org>
To: Gabriel Paubert <paubert@iram.es>
Cc: Michal Marek <mmarek@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, linux-kbuild@vger.kernel.org
Date: Fri, 05 Sep 2014 17:55:18 +1000
In-Reply-To: <20140905071344.GA16024@visitor2.iram.es>
References: <1409894927.11359.26.camel@ale.ozlabs.ibm.com>
	 <20140905071344.GA16024@visitor2.iram.es>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 09:13 +0200, Gabriel Paubert wrote:
> On Fri, Sep 05, 2014 at 03:28:47PM +1000, Michael Neuling wrote:
> > The Debian powerpc little endian architecture is called ppc64le.  This
> 
> Huh? ppc64le or ppc64el?

ppc64el.  Commit message is wrong.  Fixed below.

Mikey


From: Michael Neuling <mikey@neuling.org>

deb-pkg: Add support for powerpc little endian

The Debian powerpc little endian architecture is called ppc64el.  This
is the default architecture used by Ubuntu for powerpc.

The below checks the kernel config to see if we are compiling little
endian and sets the Debian arch appropriately.

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 35d5a58..6f4a1af 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -37,7 +37,7 @@ create_package() {
 	s390*)
 		debarch=s390$(grep -q CONFIG_64BIT=y $KCONFIG_CONFIG && echo x || true) ;;
 	ppc*)
-		debarch=powerpc ;;
+		debarch=$(grep -q CPU_LITTLE_ENDIAN=y $KCONFIG_CONFIG && echo ppc64el || echo powerpc) ;;
 	parisc*)
 		debarch=hppa ;;
 	mips*)



