Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaBNJnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:43:08 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:33225 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBNJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:43:04 -0500
Message-ID: <52FDE52A.4070002@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 10:43:06 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, fhrbata@redhat.com,
        Paul Larson <paul.larson@canonical.com>
CC: ltp-list <ltp-list@lists.sourceforge.net>,
        ltp-coverage <ltp-coverage@lists.sourceforge.net>,
        Mark Brown <mark.brown@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>
Subject: Re: [LTP] How to get the Linux kernel coverage data on ARM arch when
 I run LTP test?
References: <CA+G9fYuT4TSs=3j6K9zztsTgFNVp2YG6JT-2Q_L==1P5G+SBew@mail.gmail.com>
In-Reply-To: <CA+G9fYuT4TSs=3j6K9zztsTgFNVp2YG6JT-2Q_L==1P5G+SBew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021409-3548-0000-0000-000008132D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.02.2014 10:02, Naresh Kamboju wrote:
> root@linaro-developer:/tmp/linux-linaro-3.13-2014.01# gcov kernel/gcov/base.c -o
>  /sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/kernel/gcov/
> File 'kernel/gcov/base.c'
> Lines executed:43.18% of 44
> Creating 'base.c.gcov'
> 
> root@linaro-developer:/tmp/linux-linaro-3.13-2014.01#
> 
> The above experiment gives coverage of a single file base.c when i run
> gcov manually.
> Is there any way to get Linux kernel coverage of all files after
> running LTP test cases ?

1. Reset coverage data: lcov -z
2. Run LTP (or any other test case)
3. Capture coverage data: lcov -c -o coverage.info
4. Generate HTML output: genhtml coverage.info -o out
5. View HTML output: <browser> out/index.html

More information on lcov can be found on the page behind the second URL
your quoted in your mail.


Regards,
  Peter Oberparleiter

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

