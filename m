Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3KXQuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:50:37 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:52805 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3KXQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:50:30 -0500
Date: Sun, 24 Nov 2013 17:50:23 +0100
From: M G Berberich <berberic@fmi.uni-passau.de>
To: linux-kernel@vger.kernel.org
Subject: X509_CERTIFICATE_PARSER depends on SYSTEM_TRUSTED_KEYRING
Message-ID: <20131124165023.GB6377@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Df-Sender: MzExODAx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

seems that X509_CERTIFICATE_PARSER depends on SYSTEM_TRUSTED_KEYRING.

--- linux-3.13/crypto/asymmetric_keys/Kconfig.old       2013-11-24 17:48:22.269152229 +0100
+++ linux-3.13/crypto/asymmetric_keys/Kconfig   2013-11-24 17:48:25.120150577 +0100
@@ -29,7 +29,7 @@
 
 config X509_CERTIFICATE_PARSER
        tristate "X.509 certificate parser"
-       depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+       depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE && SYSTEM_TRUSTED_KEYRING
        select ASN1
        select OID_REGISTRY
        help


	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
