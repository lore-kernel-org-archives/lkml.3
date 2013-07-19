Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046Ab3GSS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:29:57 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:45241 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3GSS34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:29:56 -0400
X-AuditID: cbfec37d-b7f036d000004805-6a-51e985a25eca
From: Shuah Khan <shuah.kh@samsung.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] power: new trace event to print device suspend and
 resume time
Thread-topic: [PATCH v5] power: new trace event to print device suspend and
 resume time
Thread-index: AQHOhAgpp7EX8OtZ+kmNaubYSEL93w==
Date: Fri, 19 Jul 2013 18:29:53 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61743340@sisaex01sj>
References: <1374187352-3283-1-git-send-email-shuah.kh@samsung.com>
 <1374188013.3356.7.camel@gandalf.local.home>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9hP91FrS8DDfYtUbGY+bqbyaJ58Xo2
	i9n3H7NYzJqyl8ni8q45bBafe48wWlw6sIDJ4tre48wWd08dZbPoX9jLZLGv4wGTxdefDg48
	Hjtn3WX3aNl3i91j8Z6XTB77565h9/iy6hqzx/t9V9k8Hi1uYfRYsfo7u8fnTXIe67dsZQrg
	iuKySUnNySxLLdK3S+DK+PhyKlvBQZ6K1S8OsDQwbuTqYuTkkBAwkZi4axszhC0mceHeerYu
	Ri4OIYFljBJfts4BSwgJ9DJJXNpWAZGYzyhx6tB/RpAEm4C6xOfXO9hBbBEBDYmWBc9ZQIqY
	BbawSNyZNgesSFggQqJtwQM2iKJIicdfmqEa9CTaNx8Di7MIqErMndILZvMK2Evs+POOFWJz
	kcS5zdOYQGxGoPO+n1oDZjMLiEs0t95kgThbQGLJnvNQL4hKvHz8D6iXA8hWlNi+2gqiXEti
	/c7jUK3aEk/eXWCFWCUo8WPyPZYJjGKzkEydhaRlFpKWWUhaFjCyrGIUKy1OLihOSk+tMNEr
	TswtLs1L10vOz93ECIn52h2M97/aHGIU4GBU4uF98OV5oBBrYllxZe4hRgkOZiUR3oK0l4FC
	vCmJlVWpRfnxRaU5qcWHGJk4OKUaGP2v8bmIfLCI2OSo6HU/0rc5vrlCk9H2oOAfKQvfXV4F
	H5e+ZRDdKdguJZdiI/3h682rmzaVaP6OXa/yaeXqh55m+6btldt6rnb12zyLE7tWxO7iuXP/
	dGZK4J8H2/xPvZv29jmDUfCX5Ls7/nsqh/5pbV+mqF81yfKnZWnY9OcbEk7wLORwnazEUpyR
	aKjFXFScCAA5FtVs1wIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:53 PM, Steven Rostedt wrote:
> On Thu, 2013-07-18 at 16:42 -0600, Shuah Khan wrote:
>
>> +TRACE_EVENT(device_pm_report_time,
>> +
>> +	TP_PROTO(struct device *dev, const char *pm_ops, s64 ops_time,
>> +		 char *pm_event_str, int error),
>> +
>> +	TP_ARGS(dev, pm_ops, ops_time, pm_event_str, error),
>> +
>> +	TP_STRUCT__entry(
>> +		__string(device, dev_name(dev))
>> +		__string(driver, dev_driver_string(dev))
>> +		__string(parent, dev->parent ? dev_name(dev->parent) : "none")
>> +		__string(pm_ops, pm_ops ? pm_ops : "none ")
>> +		__string(pm_event_str, pm_event_str)
>> +		__field(s64, ops_time)
>> +		__field(int, error)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__assign_str(device, dev_name(dev));
>> +		__assign_str(driver, dev_driver_string(dev));
>> +		__assign_str(parent,
>> +				dev->parent ? dev_name(dev->parent) : "none");
>
> Have you tried using the temp variables? These macros expand to be
> called multiple times.
>
> -- Steve

Steve,

Tried with temp variables. Patch is on its way with temp variables. I 
generated .s with and without temp variables and didn't see any 
difference. Should I be seeing a difference, if so what am I missing?

In any case, you have the patch v6 with temp variables.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
