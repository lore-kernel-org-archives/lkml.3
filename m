Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaBOLDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:03:11 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43970 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBOLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:03:09 -0500
Message-ID: <52FF498F.1000801@kernel.org>
Date: Sat, 15 Feb 2014 11:03:43 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-iio@vger.kernel.org
Subject: Re: randconfig build error with next-20140205, in drivers/iio/kfifo_buf.c
References: <CA+r1ZhiPkKQ8gghUhNoM2rb00ppjye8hPyq97n2nxgz0L4CUfg@mail.gmail.com>
In-Reply-To: <CA+r1ZhiPkKQ8gghUhNoM2rb00ppjye8hPyq97n2nxgz0L4CUfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 22:56, Jim Davis wrote:
> Building with the attached random configuration file,
>
> warning: (AD5933 && IIO_SIMPLE_DUMMY_BUFFER && TI_AM335X_ADC) selects
> IIO_KFIFO_BUF which has unmet direct dependencies (IIO && IIO_BUFFER)
>
> drivers/iio/kfifo_buf.c:13:20: error: field 'buffer' has incomplete type
>    struct iio_buffer buffer;
>                      ^
> In file included from /home/jim/linux/arch/x86/include/asm/percpu.h:44:0,
>                   from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
>                   from include/linux/preempt.h:18,
>                   from include/linux/spinlock.h:50,
>                   from include/linux/mmzone.h:7,
>                   from include/linux/gfp.h:5,
>                   from include/linux/slab.h:14,
>                   from drivers/iio/kfifo_buf.c:1:
> drivers/iio/kfifo_buf.c: In function 'iio_request_update_kfifo':
> include/linux/kernel.h:833:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:34:26: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *buf = iio_to_kfifo(r);
>                            ^
> include/linux/kernel.h:833:48: warning: (near initialization for
> 'buf') [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:34:26: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *buf = iio_to_kfifo(r);
>                            ^
> drivers/iio/kfifo_buf.c: In function 'iio_get_length_kfifo':
> drivers/iio/kfifo_buf.c:52:10: error: dereferencing pointer to incomplete type
>    return r->length;
>            ^
> drivers/iio/kfifo_buf.c: At top level:
> drivers/iio/kfifo_buf.c:55:8: error: type defaults to 'int' in
> declaration of 'IIO_BUFFER_ENABLE_ATTR' [-Werror=implicit-int]
>   static IIO_BUFFER_ENABLE_ATTR;
>          ^
> drivers/iio/kfifo_buf.c:56:8: error: type defaults to 'int' in
> declaration of 'IIO_BUFFER_LENGTH_ATTR' [-Werror=implicit-int]
>   static IIO_BUFFER_LENGTH_ATTR;
>          ^
> drivers/iio/kfifo_buf.c:59:3: error: 'dev_attr_length' undeclared here
> (not in a function)
>    &dev_attr_length.attr,
>     ^
> drivers/iio/kfifo_buf.c:60:3: error: 'dev_attr_enable' undeclared here
> (not in a function)
>    &dev_attr_enable.attr,
>     ^
> drivers/iio/kfifo_buf.c: In function 'iio_get_bytes_per_datum_kfifo':
> drivers/iio/kfifo_buf.c:71:10: error: dereferencing pointer to incomplete type
>    return r->bytes_per_datum;
>            ^
> drivers/iio/kfifo_buf.c:71:10: error: request for member
> 'bytes_per_datum' in something not a structure or union
> drivers/iio/kfifo_buf.c:71:2: warning: return makes integer from
> pointer without a cast [enabled by default]
>    return r->bytes_per_datum;
>    ^
> In file included from /home/jim/linux/arch/x86/include/asm/percpu.h:44:0,
>                   from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
>                   from include/linux/preempt.h:18,
>                   from include/linux/spinlock.h:50,
>                   from include/linux/mmzone.h:7,
>                   from include/linux/gfp.h:5,
>                   from include/linux/slab.h:14,
>                   from drivers/iio/kfifo_buf.c:1:
> drivers/iio/kfifo_buf.c: In function 'iio_mark_update_needed_kfifo':
> include/linux/kernel.h:833:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:76:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:833:48: warning: (near initialization for 'kf')
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:76:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:834:27: error: invalid operands to binary -
> (have 'char *' and 'struct attribute **')
>    (type *)( (char *)__mptr - offsetof(type,member) );})
>                             ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:76:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> drivers/iio/kfifo_buf.c: In function 'iio_set_bytes_per_datum_kfifo':
> drivers/iio/kfifo_buf.c:83:7: error: dereferencing pointer to incomplete type
>    if (r->bytes_per_datum != bpd) {
>         ^
> drivers/iio/kfifo_buf.c:83:7: error: request for member
> 'bytes_per_datum' in something not a structure or union
> drivers/iio/kfifo_buf.c:83:25: warning: comparison between pointer and
> integer [enabled by default]
>    if (r->bytes_per_datum != bpd) {
>                           ^
> drivers/iio/kfifo_buf.c:84:4: error: dereferencing pointer to incomplete type
>     r->bytes_per_datum = bpd;
>      ^
> drivers/iio/kfifo_buf.c:84:4: error: request for member
> 'bytes_per_datum' in something not a structure or union
> drivers/iio/kfifo_buf.c:84:3: warning: statement with no effect [-Wunused-value]
>     r->bytes_per_datum = bpd;
>     ^
> drivers/iio/kfifo_buf.c: In function 'iio_set_length_kfifo':
> drivers/iio/kfifo_buf.c:95:7: error: dereferencing pointer to incomplete type
>    if (r->length != length) {
>         ^
> drivers/iio/kfifo_buf.c:95:7: error: request for member 'length' in
> something not a structure or union
> drivers/iio/kfifo_buf.c:95:16: warning: comparison between pointer and
> integer [enabled by default]
>    if (r->length != length) {
>                  ^
> drivers/iio/kfifo_buf.c:96:4: error: dereferencing pointer to incomplete type
>     r->length = length;
>      ^
> drivers/iio/kfifo_buf.c:96:4: error: request for member 'length' in
> something not a structure or union
> drivers/iio/kfifo_buf.c:96:3: warning: statement with no effect [-Wunused-value]
>     r->length = length;
>     ^
> In file included from /home/jim/linux/arch/x86/include/asm/percpu.h:44:0,
>                   from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
>                   from include/linux/preempt.h:18,
>                   from include/linux/spinlock.h:50,
>                   from include/linux/mmzone.h:7,
>                   from include/linux/gfp.h:5,
>                   from include/linux/slab.h:14,
>                   from drivers/iio/kfifo_buf.c:1:
> drivers/iio/kfifo_buf.c: In function 'iio_store_to_kfifo':
> include/linux/kernel.h:833:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:106:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:833:48: warning: (near initialization for 'kf')
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:106:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:834:27: error: invalid operands to binary -
> (have 'char *' and 'struct attribute **')
>    (type *)( (char *)__mptr - offsetof(type,member) );})
>                             ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:106:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> In file included from include/linux/mmzone.h:9:0,
>                   from include/linux/gfp.h:5,
>                   from include/linux/slab.h:14,
>                   from drivers/iio/kfifo_buf.c:1:
> drivers/iio/kfifo_buf.c:111:31: error: dereferencing pointer to incomplete type
>    wake_up_interruptible_poll(&r->pollq, POLLIN | POLLRDNORM);
>                                 ^
> include/linux/wait.h:178:12: note: in definition of macro
> 'wake_up_interruptible_poll'
>    __wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
>              ^
> drivers/iio/kfifo_buf.c:111:31: error: request for member 'pollq' in
> something not a structure or union
>    wake_up_interruptible_poll(&r->pollq, POLLIN | POLLRDNORM);
>                                 ^
> include/linux/wait.h:178:12: note: in definition of macro
> 'wake_up_interruptible_poll'
>    __wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
>              ^
> drivers/iio/kfifo_buf.c:111:2: warning: passing argument 1 of
> '__wake_up' from incompatible pointer type [enabled by default]
>    wake_up_interruptible_poll(&r->pollq, POLLIN | POLLRDNORM);
>    ^
> In file included from include/linux/mmzone.h:9:0,
>                   from include/linux/gfp.h:5,
>                   from include/linux/slab.h:14,
>                   from drivers/iio/kfifo_buf.c:1:
> include/linux/wait.h:144:6: note: expected 'struct wait_queue_head_t
> *' but argument is of type 'struct attribute * (*)[1]'
>   void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
>        ^
> In file included from /home/jim/linux/arch/x86/include/asm/percpu.h:44:0,
>                   from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
>                   from include/linux/preempt.h:18,
>                   from include/linux/spinlock.h:50,
>                   from include/linux/mmzone.h:7,
>                   from include/linux/gfp.h:5,
>                   from include/linux/slab.h:14,
>                   from drivers/iio/kfifo_buf.c:1:
> drivers/iio/kfifo_buf.c: In function 'iio_read_first_n_kfifo':
> include/linux/kernel.h:833:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:120:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:833:48: warning: (near initialization for 'kf')
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:120:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:834:27: error: invalid operands to binary -
> (have 'char *' and 'struct attribute **')
>    (type *)( (char *)__mptr - offsetof(type,member) );})
>                             ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:120:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> drivers/iio/kfifo_buf.c: In function 'iio_kfifo_buf_data_available':
> include/linux/kernel.h:833:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:138:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:833:48: warning: (near initialization for 'kf')
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:138:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> include/linux/kernel.h:834:27: error: invalid operands to binary -
> (have 'char *' and 'struct attribute **')
>    (type *)( (char *)__mptr - offsetof(type,member) );})
>                             ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:138:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(r);
>                           ^
> drivers/iio/kfifo_buf.c: In function 'iio_kfifo_buffer_release':
> include/linux/kernel.h:833:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:150:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(buffer);
>                           ^
> include/linux/kernel.h:833:48: warning: (near initialization for 'kf')
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:150:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(buffer);
>                           ^
> include/linux/kernel.h:834:27: error: invalid operands to binary -
> (have 'char *' and 'struct attribute **')
>    (type *)( (char *)__mptr - offsetof(type,member) );})
>                             ^
> drivers/iio/kfifo_buf.c:19:25: note: in expansion of macro 'container_of'
>   #define iio_to_kfifo(r) container_of(r, struct iio_kfifo, buffer)
>                           ^
> drivers/iio/kfifo_buf.c:150:25: note: in expansion of macro 'iio_to_kfifo'
>    struct iio_kfifo *kf = iio_to_kfifo(buffer);
>                           ^
> drivers/iio/kfifo_buf.c: At top level:
> drivers/iio/kfifo_buf.c:157:21: error: variable 'kfifo_access_funcs'
> has initializer but incomplete type
>   static const struct iio_buffer_access_funcs kfifo_access_funcs = {
>                       ^
> drivers/iio/kfifo_buf.c:158:2: error: unknown field 'store_to'
> specified in initializer
>    .store_to = &iio_store_to_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:158:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:158:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:159:2: error: unknown field 'read_first_n'
> specified in initializer
>    .read_first_n = &iio_read_first_n_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:159:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:159:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:160:2: error: unknown field 'data_available'
> specified in initializer
>    .data_available = iio_kfifo_buf_data_available,
>    ^
> drivers/iio/kfifo_buf.c:160:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:160:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:161:2: error: unknown field 'request_update'
> specified in initializer
>    .request_update = &iio_request_update_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:161:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:161:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:162:2: error: unknown field
> 'get_bytes_per_datum' specified in initializer
>    .get_bytes_per_datum = &iio_get_bytes_per_datum_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:162:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:162:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:163:2: error: unknown field
> 'set_bytes_per_datum' specified in initializer
>    .set_bytes_per_datum = &iio_set_bytes_per_datum_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:163:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:163:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:164:2: error: unknown field 'get_length'
> specified in initializer
>    .get_length = &iio_get_length_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:164:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:164:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:165:2: error: unknown field 'set_length'
> specified in initializer
>    .set_length = &iio_set_length_kfifo,
>    ^
> drivers/iio/kfifo_buf.c:165:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:165:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c:166:2: error: unknown field 'release'
> specified in initializer
>    .release = &iio_kfifo_buffer_release,
>    ^
> drivers/iio/kfifo_buf.c:166:2: warning: excess elements in struct
> initializer [enabled by default]
> drivers/iio/kfifo_buf.c:166:2: warning: (near initialization for
> 'kfifo_access_funcs') [enabled by default]
> drivers/iio/kfifo_buf.c: In function 'iio_kfifo_allocate':
> drivers/iio/kfifo_buf.c:177:2: error: implicit declaration of function
> 'iio_buffer_init' [-Werror=implicit-function-declaration]
>    iio_buffer_init(&kf->buffer);
>    ^
> drivers/iio/kfifo_buf.c:178:12: error: request for member 'attrs' in
> something not a structure or union
>    kf->buffer.attrs = &iio_kfifo_attribute_group;
>              ^
> drivers/iio/kfifo_buf.c:178:2: warning: statement with no effect
> [-Wunused-value]
>    kf->buffer.attrs = &iio_kfifo_attribute_group;
>    ^
> drivers/iio/kfifo_buf.c:179:12: error: request for member 'access' in
> something not a structure or union
>    kf->buffer.access = &kfifo_access_funcs;
>              ^
> drivers/iio/kfifo_buf.c:179:2: warning: statement with no effect
> [-Wunused-value]
>    kf->buffer.access = &kfifo_access_funcs;
>    ^
> drivers/iio/kfifo_buf.c:180:12: error: request for member 'length' in
> something not a structure or union
>    kf->buffer.length = 2;
>              ^
> drivers/iio/kfifo_buf.c:180:2: warning: statement with no effect
> [-Wunused-value]
>    kf->buffer.length = 2;
>    ^
> drivers/iio/kfifo_buf.c:182:2: warning: return from incompatible
> pointer type [enabled by default]
>    return &kf->buffer;
>    ^
> drivers/iio/kfifo_buf.c: At top level:
>    LD      sound/soc/codecs/snd-soc-wm8782.o
> drivers/iio/kfifo_buf.c:55:8: warning: 'IIO_BUFFER_ENABLE_ATTR'
> defined but not used [-Wunused-variable]
>   static IIO_BUFFER_ENABLE_ATTR;
>          ^
> drivers/iio/kfifo_buf.c:56:8: warning: 'IIO_BUFFER_LENGTH_ATTR'
> defined but not used [-Wunused-variable]
>   static IIO_BUFFER_LENGTH_ATTR;
>          ^
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/iio/kfifo_buf.o] Error 1\
>
Fixed by iio:ti_am335x_adc ensure that IIO_KFIFO_BUF is not selected witout IIO_BUFFER
09f33c332018be05cdaebf14a75ea232810948d0

Thanks
