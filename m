Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162666Ab3DETuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:50:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:46068 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162072Ab3DETuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:50:17 -0400
Message-ID: <515F2AF3.9050709@semaphore.gr>
Date: Fri, 05 Apr 2013 22:50:11 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com> <CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com> <3060957.HxB12olH3c@vostro.rjw.lan> <515CBB98.4020607@semaphore.gr> <CAKohpomV7uSS1suFKGiGJfGvvqodKHhvc_uO3WsR4jzUg+1o9g@mail.gmail.com>
In-Reply-To: <CAKohpomV7uSS1suFKGiGJfGvvqodKHhvc_uO3WsR4jzUg+1o9g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050608000605020000050000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050608000605020000050000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Viresh,

On 04/04/2013 07:54 AM, Viresh Kumar wrote:
> Hi Stratos,
> 
> Yes, your results show some improvements. BUT if performance is the only thing
> we were looking for, then we will never use ondemand governor but performance
> governor.
> 
> I suspect this little increase in performance must have increased power numbers
> too (significantly). So, if you can get numbers in the form of power/performance
> with and without your patch, it will be great.
> 
> --
> viresh
> 

I run some more tests. I increased the number of iterations to 100 (from 20). 
I also test for counter 1,000,000 (~4200us), 5,000,000 (~10000us), 15,000,000 (~30000us).

This time, I also extracted statistics from cpufreq_stats driver. I think this will be an
indication for power consumption. Below the results and attached the program I used for to
get these numbers.

Thanks for your time,
Stratos

--------------------------

counter 1,000,000
average diff: 0.184%

run 0
-----
cpufreq off     on
------- ------- ----
3401000 686     702
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       0
1700000 0       0
1600000 4957    4940
early_demand off: 4207 us
early_demand on: 4214 us
diff: -0.17%

run 1
-----
cpufreq off     on
------- ------- ----
3401000 513     665
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       0
1700000 0       0
1600000 5130    4978
early_demand off: 4208 us
early_demand on: 4194 us
diff: 0.33%

run 2
-----
cpufreq off     on
------- ------- ----
3401000 630     487
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       0
1700000 0       0
1600000 5013    5155
early_demand off: 4210 us
early_demand on: 4200 us
diff: 0.24%

run 3
-----
cpufreq off     on
------- ------- ----
3401000 666     602
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       0
1700000 0       0
1600000 4976    5040
early_demand off: 4205 us
early_demand on: 4183 us
diff: 0.52%

run 4
-----
cpufreq off     on
------- ------- ----
3401000 527     725
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       0
1700000 0       0
1600000 5116    4917
early_demand off: 4193 us
early_demand on: 4193 us
diff: 0.00%
-------------------------


counter 5,000,000
average diff: 1.184%

run 0
-----
cpufreq off     on
------- ------- ----
3401000 1994    2294
3400000 0       0
3300000 0       49
3100000 40      0
3000000 11      1
2900000 0       49
2800000 0       1
2600000 0       0
2500000 0       0
2400000 55      0
2200000 0       4
2100000 0       0
2000000 0       0
1900000 46      1
1700000 0       0
1600000 3558    3304
early_demand off: 10423 us
early_demand on: 10441 us
diff: -0.17%

run 1
-----
cpufreq off     on
------- ------- ----
3401000 2112    2174
3400000 0       0
3300000 7       38
3100000 0       0
3000000 49      0
2900000 0       49
2800000 39      0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       1
2000000 0       0
1900000 37      38
1700000 44      11
1600000 3416    3390
early_demand off: 10538 us
early_demand on: 10239 us
diff: 2.83%

run 2
-----
cpufreq off     on
------- ------- ----
3401000 2107    2296
3400000 0       0
3300000 0       0
3100000 0       22
3000000 95      0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 49      11
2200000 0       0
2100000 0       0
2000000 0       49
1900000 11      34
1700000 0       0
1600000 3443    3291
early_demand off: 10434 us
early_demand on: 10439 us
diff: -0.05%

run 3
-----
cpufreq off     on
------- ------- ----
3401000 2106    2308
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       11
2900000 0       0
2800000 0       0
2600000 0       0
2500000 59      0
2400000 13      46
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       4
1700000 0       0
1600000 3527    3333
early_demand off: 10541 us
early_demand on: 10238 us
diff: 2.87%

run 4
-----
cpufreq off     on
------- ------- ----
3401000 1899   2197
3400000 0      0   
3300000 0      0   
3100000 49     99  
3000000 0      0   
2900000 0      0   
2800000 21     0   
2600000 0      0   
2500000 0      0   
2400000 0      0   
2200000 0      0   
2100000 0      0   
2000000 20     0   
1900000 4      11  
1700000 0      14  
1600000 3710   3383
early_demand off: 10432 us
early_demand on: 10339 us
diff: 0.89%
--------------------------


counter 10,000,000
average diff: 0.336%

run 0
-----
cpufreq off     on
------- ------- ----
3401000 2106    2232
3400000 0       0
3300000 0       42
3100000 29      0
3000000 0       0
2900000 0       0
2800000 49      0
2600000 0       0
2500000 0       0
2400000 11      49
2200000 0       0
2100000 0       0
2000000 52      0
1900000 47      0
1700000 0       0
1600000 3507    3478
early_demand off: 20169 us
early_demand on: 20036 us
diff: 0.66%

run 1
-----
cpufreq off     on
------- ------- ----
3401000 2210    2146
3400000 0       0
3300000 44      0
3100000 49      10
3000000 0       0
2900000 3       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       3
1700000 0       0
1600000 3496    3643
early_demand off: 20142 us
early_demand on: 20137 us
diff: 0.03%

run 2
-----
cpufreq off     on
------- ------- ----
3401000 2133    2135
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       35
2600000 0       0
2500000 21      0
2400000 53      39
2200000 0       0
2100000 0       0
2000000 49      0
1900000 38      49
1700000 0       48
1600000 3506    3495
early_demand off: 20037 us
early_demand on: 19934 us
diff: 0.51%

run 3
-----
cpufreq off     on
------- ------- ----
3401000 2166    2125
3400000 0       0
3300000 0       0
3100000 0       5
3000000 11      0
2900000 43      0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       55
2200000 28      0
2100000 8       54
2000000 0       0
1900000 0       34
1700000 11      0
1600000 3535    3525
early_demand off: 20038 us
early_demand on: 19940 us
diff: 0.49%

run 4
-----
cpufreq off     on
------- ------- ----
3401000 2122    2125
3400000 0       0
3300000 25      0
3100000 0       5
3000000 29      0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       55
2200000 0       0
2100000 0       54
2000000 0       0
1900000 0       34
1700000 0       0
1600000 3626    3525
early_demand off: 20037 us
early_demand on: 20039 us
diff: -0.01%
--------------------------


counter 15,000,000
average diff: 0.21%


run 0
-----
cpufreq off     on
------- ------- ----
3401000 2226    2262
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 22      0
2200000 0       0
2100000 0       49
2000000 38      0
1900000 60      0
1700000 0       0
1600000 3555    3592
early_demand off: 29940 us
early_demand on: 30038 us
diff: -0.33%

run 1
-----
cpufreq off     on
------- ------- ----
3401000 2466    2582
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       38
2400000 37      0
2200000 0       11
2100000 0       0
2000000 0       11
1900000 0       0
1700000 0       0
1600000 3400    3260
early_demand off: 30033 us
early_demand on: 29934 us
diff: 0.33%

run 2
-----
cpufreq off     on
------- ------- ----
3401000 2545    2195
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 24      4
2200000 0       4
2100000 34      0
2000000 6       0
1900000 0       0
1700000 0       0
1600000 3294    3700
early_demand off: 30131 us
early_demand on: 30028 us
diff: 0.34%

run 3
-----
cpufreq off     on
------- ------- ----
3401000 2327    2362
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 2       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 11      0
2000000 0       1
1900000 0       0
1700000 4       39
1600000 3558    3500
early_demand off: 29938 us
early_demand on: 29930 us
diff: 0.03%

run 4
-----
cpufreq off     on
------- ------- ----
3401000 2303    2246
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       11
2500000 9       0
2400000 56      0
2200000 0       0
2100000 11      0
2000000 0       0
1900000 0       49
1700000 0       0
1600000 3525    3596
early_demand off: 30137 us
early_demand on: 29931 us
diff: 0.68%
--------------------------


counter 20,000,000
average diff: 0.038%

run 0
-----
cpufreq off     on
------- ------- ----
3401000 2498    2483
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 1       0
1900000 0       19
1700000 0       33
1600000 3504    3468
early_demand off: 39917 us
early_demand on: 39925 us
diff: -0.02%

run 1
-----
cpufreq off     on
------- ------- ----
3401000 2338   2405 
3400000 0      0 
3300000 0      0 
3100000 0      0 
3000000 0      0 
2900000 0      0 
2800000 0      0 
2600000 0      0 
2500000 0      0 
2400000 0      0 
2200000 0      0 
2100000 0      0 
2000000 0      0 
1900000 75     9 
1700000 0      0 
1600000 3593   3589 
early_demand off: 40130 us
early_demand on: 39927 us
diff: 0.51%

run 2
-----
cpufreq off     on
------- ------- ----
3401000 2344    2342
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 17      49
2000000 0       0
1900000 32      0
1700000 0       0
1600000 3610    3612
early_demand off: 39930 us
early_demand on: 39930 us
diff: 0.00%

run 3
-----
cpufreq off     on
------- ------- ----
3401000 2631    2490
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       37
1700000 0       12
1600000 3373    3465
early_demand off: 39937 us
early_demand on: 39938 us
diff: 0.00%

run 4
-----
cpufreq off     on
------- ------- ----
3401000 2298    2451
3400000 0       0
3300000 0       0
3100000 0       0
3000000 0       0
2900000 0       0
2800000 0       0
2600000 0       0
2500000 0       0
2400000 0       0
2200000 0       0
2100000 0       0
2000000 0       0
1900000 0       0
1700000 0       0
1600000 3708    3553
early_demand off: 40126 us
early_demand on: 39937 us
diff: 0.47%


--------------050608000605020000050000
Content-Type: text/x-csrc;
 name="bench.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bench.c"

#define _GNU_SOURCE
#include <pthread.h>
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <sched.h>

struct timeval start, end;
unsigned long long i, cnt;
long utime, seconds, useconds;

void enable_early() {
	system("echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/early_demand");
        system("rmmod cpufreq_stats");
        system("modprobe cpufreq_stats");
}

void disable_early() {
        system("echo 0 > /sys/devices/system/cpu/cpufreq/ondemand/early_demand");
	system("rmmod cpufreq_stats");
	system("modprobe cpufreq_stats");
}

void calibrate()
{
	sleep(1);

	gettimeofday(&start, NULL);

	for (i = 0; i < 1000000000; i++);

	gettimeofday(&end, NULL);
	seconds = end.tv_sec - start.tv_sec;
	useconds = end.tv_usec - start.tv_usec;
	utime = seconds * 1000000 + useconds;
	
	printf("Calibrating\n");
	printf("Elapsed time: %ld microseconds\n", utime);

	/* find the counter for 10ms */
	cnt = i * 10000 / utime;

	printf("cnt: %ld\n", cnt);
}

long do_bench()
{
	gettimeofday(&start, NULL);

	for (i = 0; i < cnt; i++);

	gettimeofday(&end, NULL);
	seconds = end.tv_sec - start.tv_sec;
	useconds = end.tv_usec - start.tv_usec;
	utime = seconds * 1000000 + useconds;
	
	printf("Elapsed time: %ld microseconds\n", utime);

	return utime;
}

void benchmark()
{
	const int iter = 100;
	long total_off = 0;
	long total_on = 0;
	double diff_perc;
	unsigned int i;

	/* calibrate(); */
	cnt = 1000000;

	disable_early();
	sleep(1);
	do_bench(); /* do a first benchmark but do not count in total */	
	sleep(5);

	for (i = 0; i < iter; i++) {
		total_off += do_bench();
		
		usleep(500000);
	}
	total_off /= iter;

	system("cat /sys/devices/system/cpu/cpu2/cpufreq/stats/time_in_state");

	enable_early();
	sleep(1);
	do_bench(); /* do a first benchmark but do not count in total */
	sleep(5);

	for (i = 0; i < iter; i++) {
                total_on += do_bench();

                usleep(500000);
        }
        total_on /= iter;

	system("cat /sys/devices/system/cpu/cpu2/cpufreq/stats/time_in_state");
	diff_perc = (total_off - total_on) * 100;
	diff_perc /= total_off;

	printf("early_demand off: %ld us\n", total_off);
        printf("early_demand on: %ld us\n", total_on);
	printf("diff: %f\n", diff_perc);
}

main ()
{
	int i;

	cpu_set_t  mask;
	CPU_ZERO(&mask);
	CPU_SET(2, &mask);
	sched_setaffinity(0, sizeof(mask), &mask);

	printf("Starting benchmark\n");
	
	for (i = 0; i < 5; i++) {
		printf("run %i\n", i);
		benchmark();
	}
}

--------------050608000605020000050000--
