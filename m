Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaFNWkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:40:52 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:36256 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaFNWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:40:50 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ced1401: userspace: use1401.c:  Cleaning up potential strncpy missing null-terminate 
Date: Sun, 15 Jun 2014 00:41:46 +0200
Message-Id: <1402785707-12383-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
There is also a wrong use of strncat, it should have used sizeof - strlen.

This was found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  staging: ced1401: userspace: use1401.c:  Cleaning up potential strncpy missing null-terminate

 drivers/staging/ced1401/userspace/use1401.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

-- 
1.7.10.4

