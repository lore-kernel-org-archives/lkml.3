Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbaGXQ4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:56:07 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:36304 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbaGXQ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:56:05 -0400
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2014 12:56:05 EDT
Message-ID: <53D135F9.1070104@tu-dresden.de>
Date: Thu, 24 Jul 2014 18:36:09 +0200
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Perf: cannot overide PYTHON(_CONFIG)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear perf maintainers,

It is documented in Makefile.perf and the Python 3 error message to use
make PYTHON=python2. However this does not work anymore since
9734163b6ee1425c6fa4b65d7e6ce34c9079420d moved the libpython feature check.

Further it would be more portable anyway to use "python2" as default
instead of "python" as long as python3 is not supported. This follows
the PEP 394 recommendation: https://www.python.org/dev/peps/pep-0394


I am not sure how to correctly fix the failure to respect
PYTHON(_CONFIG). I would assume that early in perf/config/Makefile
FEATURE_CHECK_[CFLAGS|LDFLAGS]-libpython(-version) needs to be set
(before the feature checks are executed) and that the reconstruction of
FLAGS_PYTHON_EMBED based on hardcoded python-config needs to be removed.

Best Regards,
Thomas
-- 
Dipl. Inf. Thomas Ilsche
Computer Scientist
Highly Adaptive Energy-Efficient Computing
CRC 912 HAEC: http://tu-dresden.de/sfb912
Technische Universität Dresden
Center for Information Services and High Performance Computing (ZIH)
01062 Dresden, Germany

Phone: +49 351 463-42168
Fax: +49 351 463-3773
E-Mail: thomas.ilsche@tu-dresden.de
