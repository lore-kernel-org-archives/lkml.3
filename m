Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaLOQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:42:23 -0500
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:55259 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbaLOQmW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:42:22 -0500
From: "Young, David" <dayoung@akamai.com>
To: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "Shuah Khan (shuahkhan@gmail.com)" <shuahkhan@gmail.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2014 11:42:12 -0500
Subject: selftests: standardized results output?
Thread-Topic: selftests: standardized results output?
Thread-Index: AdAYhhLiR9kJBNa8RRu7UNdiydnNNQ==
Message-ID: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3DABAC24@USMBX1.msg.corp.akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  I'm looking into what sorts of tools can consume the selftest output, and
found this on the wikipage:

https://kselftest.wiki.kernel.org/standardize_the_test_output

The current suggestion (as of the last-modified date on that wiki page for
October) is to use the Test Anything Protocol [TAP] for standard output.  I
notice that there is at least one test that conforms to TAP output, but
the majority of the tests are not using it.

There's also the kselftest.h file that suggests exit codes for the individual
test applications.

I'm interested in knowing what is the intention of this standardization, so
that I can put some work into a "glue" layer for a tool like buildbot,
autotest, or Jenkins for executing and consuming the results of these
selftests.

1) Is this output standard a "nice to have" that won't be much enforced?
2) Will the exit codes be utilized outside of the current makefile-based
   approach for executing the tests?  The current make target just runs all the
   tests without really concerning itself with the exit values of the
   individual tests.  It's simple, which isn't a bad thing, but it lacks a
   summarized result.  Is the intention to use a different harness to consume
   and report results?
3) Are the TAP results intended to be the exclusive (std)output of the tests,
   or will the tests report in a hybrid fashion?
   Such an example would be a test that produces some verbose stdout to the
   console, while simultaneously creating a TAP-compliant results.tap file as
   well... or vice versa with the stdout being TAP and a more verbose but
   free-form log.txt 

Thanks,

- David Young
