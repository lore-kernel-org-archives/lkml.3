Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3AYMqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:46:21 -0500
Received: from mail.atsec.com ([195.30.99.214]:48435 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab3AYMqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:46:18 -0500
Message-ID: <51027E99.1060908@atsec.com>
Date: Fri, 25 Jan 2013 13:46:17 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic
 if those are unsigned
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124190610.GI6538@redacted.bos.redhat.com> <874ni6qhlq.fsf@rustcorp.com.au>
In-Reply-To: <874ni6qhlq.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2013 00:36:01, +0100, Rusty Russell <rusty@rustcorp.com.au> wrote:

Hi Rusty at al,

while we are at FIPS discussions, may I propose a slight fix because the
FIPS mode is not covering the FIPS 200 (a management system set of
requirements), but FIPS 140-2 covering implementation requirements for
cryptography.

Signed-off-by: Stephan Mueller <smueller@chronox.de>

--- Kconfig.orig        2013-01-25 13:42:54.649705380 +0100
+++ Kconfig     2013-01-25 13:43:16.737705712 +0100
@@ -22,11 +22,11 @@
 comment "Crypto core or helper"

 config CRYPTO_FIPS
-       bool "FIPS 200 compliance"
+       bool "FIPS 140-2 compliance"
        depends on CRYPTO_ANSI_CPRNG && !CRYPTO_MANAGER_DISABLE_TESTS
        help
          This options enables the fips boot option which is
-         required if you want to system to operate in a FIPS 200
+         required if you want to system to operate in a FIPS 140-2
          certification.  You should say no unless you know what
          this is.
